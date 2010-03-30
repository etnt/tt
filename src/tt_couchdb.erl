%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2009-2010, Torbjorn Tornkvist
%%% @doc Simple CouchDB access primitives.
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_couchdb).

-export([scores/0
         ,matches/0
        ]).

-export([http_get_req/1
         ,http_post_req/2
         ,http_post_req/3
         ,http_put_req/2
         ,http_put_req/3
         ,find/2
        ]).


scores() ->
    call_couchdb("http://localhost:5984",
                 "/tt/_design/tt/_view/scores").

matches() ->
    call_couchdb("http://localhost:5984",
                 "/tt/_design/tt/_view/matches").


call_couchdb(Url, Path) ->
    R = http_get_req(Url++Path),
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
