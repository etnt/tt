%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_data_resource).
-export([init/1
         ,resource_exists/2
         ,content_types_provided/2
         ,return_data/2
        ]).

-include_lib("webmachine/include/webmachine.hrl").

-define(dbg(S,A), io:format("~p(~p): "++S,[?MODULE,?LINE|A])).
%%-define(dbg(S,A), true).

init(Context) -> {ok, Context}.

resource_exists(ReqData, State) -> {true, ReqData, State}. % FIXME

content_types_provided(ReqData, Context) ->
    {[{"text/javascript",         return_data}
      ,{"application/javascript", return_data}
     ], ReqData, Context}.

return_data(ReqData, Context) ->
    {data(ReqData), 
     tt_utils:set_content_type(ReqData, "application/json"),
     Context}.

data(ReqData) ->
    data(wrq:path_info(what,ReqData),ReqData).

data("ranking", _ReqData) ->
    D = {obj,[{ranking, tt_couchdb:users()}]},
    tt_utils:json_return_object(<<"Ranking">>,D);
data("match", ReqData) ->
    Emsg = case validate_figures(wrq:get_qs_value("figures",ReqData)) of
               ok -> 
                   store_match(ReqData),
                   <<"Registration succeeded!">>;

               {error, Msg} when is_binary(Msg) -> 
                   Msg
           end,
    tt_utils:json_return_object(<<"Register">>, {obj,[]}, Emsg).

validate_figures(_) ->
    ok.

store_match(ReqData) ->
    L = [{Key,list_to_binary(wrq:get_qs_value(Key,ReqData))} 
         || Key <- ["winner","looser","figures"]],
    Winner = wrq:get_qs_value("winner", ReqData),
    Looser = wrq:get_qs_value("looser", ReqData),
    update_score_wl(Winner, Looser, tt_couchdb:users()),
    tt_couchdb:store_doc([{"type",<<"match">>}|L]).

update_score_wl(Winner, Looser, Users) ->
    {WScore, LScore} = new_scores(Winner, Looser, Users, {0, 0}),
    io:format("~p ~p~n", [WScore, LScore]).

new_scores(Winner, Looser, [{obj, [{"nick", Winner}, {"score", WS}]}|T],
	   {_, LS}) ->
    new_scores(Winner, Looser, T, {WS, LS});
new_scores(Winner, Looser, [{obj, [{"nick", Looser}, {"score", LS}]}|T],
	   {WS, _}) ->
    new_scores(Winner, Looser, T, {WS, LS});
new_scores(Winner, Looser, [_|T], {WS, LS}) ->
    new_scores(Winner, Looser, T, {WS, LS});
new_scores(_Winner, _Looser, [], {WS, LS}) ->
    tt_scoring:v1(WS, LS).
