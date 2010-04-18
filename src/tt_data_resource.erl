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
    D = {obj,[{scores, tt_couchdb:scores()}]},
    tt_utils:json_return_object(<<"Ranking">>,D);
data("match", ReqData) ->
    ?dbg("match: ~p~n",
         [ [wrq:get_qs_value(Key,ReqData) || Key <- ["winner","looser","figures"]]]),
    register_scores(ReqData).

register_scores(ReqData) ->
    Emsg = case validate_figures(wrq:get_qs_value("figures",ReqData)) of
               ok -> 
                   store_scores(ReqData),
                   <<"Registration succeeded!">>;

               {error, Msg} when is_binary(Msg) -> 
                   Msg
           end,
    tt_utils:json_return_object(<<"Register">>, {obj,[]}, Emsg).

validate_figures(_) ->
    ok.

store_scores(ReqData) ->
    L = [{Key,list_to_binary(wrq:get_qs_value(Key,ReqData))} 
         || Key <- ["winner","looser","figures"]],
    tt_couchdb:store_doc([{"type",<<"match">>}|L]).
