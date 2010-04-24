%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2009-2010, Torbjorn Tornkvist
%%% @doc Simple CouchDB access primitives.
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_couchdb).

-export([init/0
	 ,scores/0
         ,matches/0
	 ,users/0
	 ,ranking/0
	 ,get_user/1
         ,store_doc/1
         ,store_doc/2
	 ,update_user/1
        ]).

-export([http_get_req/1
         ,http_post_req/2
         ,http_post_req/3
         ,http_put_req/2
         ,http_put_req/3
         ,find/2
        ]).


-define(DB_NAME, "tt").
-define(HOST, "http://localhost:5984/").
-define(DESIGN_DOC, "_design/tt").
-define(SCORES_VIEW, "scores").
-define(MATCHES_VIEW, "matches").
-define(USERS_VIEW, "users").
-define(RANKING_VIEW, "ranking").
-define(VIEWS_PATH, ?HOST ++ ?DB_NAME ++ "/" ++ ?DESIGN_DOC ++ "/_view/").
-define(DESIGN_PATH, ?HOST ++ ?DB_NAME ++ "/" ++ ?DESIGN_DOC).


%% @doc Create the tt database if it doesn't exist. Also create the views
%% if they don't exist
init() ->
    DbList = http_get_req(?HOST ++ "_all_dbs"),
    case lists:member(list_to_binary(?DB_NAME), DbList) of
	true ->
	    ok;
	false ->
	    http_put_req(?HOST ++ ?DB_NAME, [])
    end,
    init_design_doc(),
    ok.

%% @doc Create the tt design document if it doesn't exist
init_design_doc() ->
    try
	http_get_req(?DESIGN_PATH)
    catch
	throw:_ ->
	    Z = [{"_id", list_to_binary(?DESIGN_DOC)},
		 {"views", {obj, views()}}],
	    Body = rfc4627:encode({obj, Z}),
	    http_put_req(?DESIGN_PATH, Body)
    end.

views() ->
    [{?SCORES_VIEW, {obj, [{"map", list_to_binary(scores_map())}]}},
     {?MATCHES_VIEW, {obj, [{"map", list_to_binary(matches_map())}]}},
     {?USERS_VIEW, {obj, [{"map", list_to_binary(users_map())}]}},
     {?RANKING_VIEW, {obj, [{"map", list_to_binary(ranking_map())}]}}].

scores_map() ->
    "function(doc) {"
	"if(doc.type == 'score')"
	"emit(doc.score, {nick:doc.nick, score:doc.score}); }".

matches_map() ->
    "function(doc) {"
	"if(doc.type == 'match')"
	"emit(doc.gsec, {winner:doc.winner, looser:doc.looser,"
	"figures:doc.figures, gsec:doc.gsec}); }".

users_map() ->
    "function(doc) {"
	"if(doc.type == 'user')"
	"emit(doc.nick, doc);}".

ranking_map() ->
    "function(doc) {"
	"if(doc.type == 'user')"
	"emit(doc.score, {nick:doc.nick, score:doc.score});}".


%%
%% @doc Take a key-value tuple list and store it as a new CouchDB document.
%%
store_doc(KeyValList) ->
    store_doc(KeyValList, tt:gnow()).

store_doc(KeyValList, Created) ->
    Z = [{"gsec", Created},
         {"created_tz", list_to_binary(lists:flatten(tt:rfc3339(Created)))}
         | KeyValList],
    Body = rfc4627:encode({obj, Z}),
    http_post_req(?HOST ++ ?DB_NAME, Body).

%%
%% @doc Get the scores from the db
%%
scores() ->
    get_from_couchdb(?VIEWS_PATH ++ ?SCORES_VIEW).

%%
%% @doc Get the matches from the db
%%
matches() ->
    get_from_couchdb(?VIEWS_PATH ++ ?MATCHES_VIEW).

%%
%% @doc Get the users from the db
%%
users() ->
    get_from_couchdb(?VIEWS_PATH ++ ?USERS_VIEW).

%%
%% @doc Get the ranking of the users from the db
%%
ranking() ->
    get_from_couchdb(?VIEWS_PATH ++ ?RANKING_VIEW).

%%
%% @doc Get a user from the db
%%
get_user(User) ->
    {obj, PL} = http_get_req(?VIEWS_PATH ++ ?USERS_VIEW ++ 
				 "?key=\"" ++ User ++ "\""),
    case proplists:get_value("rows", PL) of
	[] ->
	    no_exists;
	[{obj, [_Id, _Key, {"value", {obj, Data}}]}] ->
	    Data
    end.

%%
%% @doc Update a user document
%%
update_user(User) ->
    Id = binary_to_list(proplists:get_value("_id", User)),
    http_put_req(?HOST ++ ?DB_NAME ++ "/" ++ Id, rfc4627:encode({obj, User})).
    

get_from_couchdb(Url) ->
    R = http_get_req(Url),
    %% Just preserve the Json
    F = fun(X) -> {true,X} end,
    find(F, ["rows","value"], R).


%%%
%%% HTTP access
%%%

http_get_req(Url) ->
    case http:request(Url) of
        {ok,{{_,200,_}, _Headers, Content}} ->
            {ok, Json, []} = rfc4627:decode(Content),
            Json;
        Else ->
            throw(Else)
    end.


http_post_req(Url, Body) ->
    http_post_req(Url, Body, []).

http_post_req(Url, Body, Hdrs) ->
    http_req(post, Url, Body, Hdrs).


http_put_req(Url, Body) ->
    http_put_req(Url, Body, []).

http_put_req(Url, Body, Hdrs) ->
    http_req(put, Url, Body, Hdrs).

http_req(Method, Url, Body, Hdrs) ->
    ContentType = "application/json",
    Request = {Url, Hdrs, ContentType, Body},
    http:request(Method, Request, [], []).

   
%%
%% @doc Traverse and extract data from a CouchDB reply.
%%
%%   find(["rows","value","text"],Json).
%%   find(fun(X) -> {true,element(2,X)} end, ["rows","value"],Jsonu).
%%
%% @end

find(Path, Json) ->
    find(fun(X) -> {true,X} end, Path, Json).

find(_, []      , _)                     -> [];
find(F, Path    , {obj,L})               -> fold(F, Path, L);
find(F, [Key]   , {Key,Val})             ->
    case F(Val) of
        {true, Res} -> [Res];
        false       -> []
    end;
find(F, [H|Path], {H,{obj,L}})           -> fold(F, Path, L);
find(F, [H|Path], {H,L}) when is_list(L) -> fold(F, Path, L);
find(_, _       , _)                     -> [].


fold(F, Path, Input) ->
    lists:foldl(fun(E,Acc) ->
                        case find(F,Path,E) of
                            [] -> Acc;
                            X -> X++Acc
                        end
                end, [], Input).
