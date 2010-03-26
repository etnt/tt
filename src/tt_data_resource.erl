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
         ,set_content_type/1
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
    ?dbg("content_types_provided , what=~p~n",[catch wrq:path_info(what,ReqData)]),
    {data(catch wrq:path_info(what,ReqData)), ReqData, Context}.

data("ranking") ->
    D = {obj,[{scores, [{obj,X} || X <- get_scores()]}]},
    json_return_object('Ranking',D).

%% Test data    
get_scores() ->
    [[{name,tobbe},{score,200}],
     [{name,peter},{score,12}]].

%%
%% Json return object: {data:D, header:H, emsg:E}
%%
json_return_object(Header, Data) ->
    json_return_object(Header, Data, "").

json_return_object(Header, Data, Emsg) ->
    rfc4627:encode({obj,[{header,Header},
                         {data,  Data},
                         {emsg,  Emsg}]}).
     

set_content_type(ReqData) ->
    set_content_type(ReqData, "text/javascript").
        
set_content_type(ReqData, ContentType) ->
    ?dbg("ContentType: ~p~n",[ContentType]),
    wrq:set_resp_headers([{"content-type",ContentType}], ReqData).
