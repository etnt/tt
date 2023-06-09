%%%-------------------------------------------------------------------
%%% @author Jordi Chacon <jordi.chacon@gmail.com>
%%% @copyright (C) 2010, Jordi Chacon
%%% @doc Module that represents the match resource
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_matches_resource).
-export([init/1]).
-export([allowed_methods/2,
	 content_types_provided/2,
	 content_types_accepted/2,
	 create_match/2,
         post_is_create/2,
	 return_data/2,
         create_path/2]).

-include_lib("webmachine/include/webmachine.hrl").


init(Context) -> {ok, Context}.

allowed_methods(ReqData, Context) ->
    {['GET', 'POST'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
    {[{"text/javascript",         return_data}
      ,{"application/javascript", return_data}
     ], ReqData, Context}.

%% /matches return the matches sorted by date
return_data(ReqData, Context) ->    
    case wrq:disp_path(ReqData) of
	[] ->
	    Matches = parse_dates(tt_couchdb:matches()),
	    Data = {<<"Matches">>, {obj, [{matches, Matches}]}},
	    tt_utils:return(Data, ReqData, Context)
    end.

parse_dates(Matches) ->
    parse_dates(Matches, [], 50).
parse_dates(_Matches, Acc, 0) ->
    lists:reverse(Acc);
parse_dates([{obj,Match}|T], Acc, N) ->
    Gsecs = proplists:get_value("gsec", Match),
    Match2 = proplists:delete("gsec", Match),
    Match3 = {obj,[{"date", list_to_binary(tt:friendly_date(Gsecs))} | Match2]},
    parse_dates(T, [Match3 | Acc], N - 1);
parse_dates([], Acc, _N) ->
    lists:reverse(Acc).

%%
%% Functions that handle the creation of a new match
%%
content_types_accepted(ReqData, Context) ->
    CT = wrq:get_req_header("content-type", ReqData),
    {MT, _Params} = webmachine_util:media_type_to_detail(CT),
    {[{MT, create_match}], ReqData, Context}.

post_is_create(ReqData, Context) ->
    {true, ReqData, Context}.

create_path(ReqData, Context) ->
  case wrq:peer(ReqData) =:= "213.136.42.60" of
      true ->
	  {"newmatch", ReqData, Context};
      false ->
	  {no_rights, ReqData, Context}
  end.

create_match(ReqData, Context) ->
    PL = mochiweb_util:parse_qs(wrq:req_body(ReqData)),
    L = [{Key, list_to_binary(proplists:get_value(Key, PL))} 
         || Key <- ["winner","looser"]],
    Winner = proplists:get_value("winner", PL),
    Looser = proplists:get_value("looser", PL),
    WFigures = proplists:get_value("wfigures", PL),
    LFigures = proplists:get_value("lfigures", PL),
    Figures = list_to_binary(WFigures ++ "-" ++ LFigures),
    update_score_wl(Winner, Looser),
    tt_couchdb:store_doc([{"type",<<"match">>}, {"figures", Figures}|L]),
    {true, ReqData, Context}.

update_score_wl(WinnerNick, LooserNick) ->
    Winner = tt_couchdb:get_user(WinnerNick),
    Looser = tt_couchdb:get_user(LooserNick),
    {WScore, LScore} = tt_scoring:gen_new_scores(
			 proplists:get_value("score",Winner),
			 proplists:get_value("score",Looser)),
    update_user_score(Winner, WScore, winner),
    update_user_score(Looser, LScore, looser).

update_user_score(User, NewScore, Result) ->
    NewMatches = proplists:get_value("matches", User) + 1,
    User2 = proplists:delete("score", User),
    User3 = proplists:delete("matches", User2),
    {Tuple, User4} = 
	case Result of
	    winner ->
		NewWins = proplists:get_value("wins", User3) + 1,
		{{"wins", NewWins}, proplists:delete("wins", User3)};
	    looser ->
		NewLosses = proplists:get_value("losses", User3) + 1,
		{{"losses", NewLosses}, proplists:delete("losses", User3)}
	end,
    User5 = [{"score", NewScore}, {"matches", NewMatches}, Tuple | User4],
    tt_couchdb:update_user(User5).
