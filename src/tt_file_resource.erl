%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_file_resource).
-export([init/1
         ,resource_exists/2
         ,content_types_provided/2
         ,return_file/2
         ,return_the_file/1
         ,file_path/1
        ]).

-include_lib("webmachine/include/webmachine.hrl").

-define(dbg(S,A), io:format("~p(~p): "++S,[?MODULE,?LINE|A])).
%%-define(dbg(S,A), true).

init([Prefix]) -> {ok, orddict:from_list([{prefix,Prefix}])}.

resource_exists(ReqData, State) -> {true, ReqData, State}. % FIXME


content_types_provided(ReqData, Context) ->
    {[{"text/html",               return_file}
      ,{"text/xml",               return_file}
      ,{"text/css",               return_file}
      ,{"text/javascript",        return_file}
      ,{"application/javascript", return_file}
      ,{"image/png",              return_file}
      ,{"image/jpg",              return_file}
     ], ReqData, Context}.

return_file(ReqData, Context) ->
    try 
        ?dbg("Context=~p , Path=~p~n",[Context, wrq:path_tokens(ReqData)]),
        {do_return_file(ReqData, Context), set_content_type(ReqData), Context}
    catch
        _:_ -> 
            {"", ReqData, Context}
    end.

set_content_type(ReqData) ->
    case lists:reverse(string:tokens(hd(lists:reverse(wrq:path_tokens(ReqData))), ".")) of
        ["html"|_] -> set_content_type(ReqData, "test/html");
        ["js"|_]   -> set_content_type(ReqData, "text/javascript");
        ["css"|_]  -> set_content_type(ReqData, "text/css");
        ["png"|_]  -> set_content_type(ReqData, "image/png");
        ["jpg"|_]  -> set_content_type(ReqData, "image/jpg");
        _          -> set_content_type(ReqData, "application/octet")
    end.
        
set_content_type(ReqData, ContentType) ->
    ?dbg("ContentType: ~p~n",[ContentType]),
    wrq:set_resp_headers([{"content-type",ContentType}], ReqData).

do_return_file(ReqData, Context) ->
    return_the_file(return_filename(ReqData, Context)).

return_the_file(Fname) ->
    ?dbg("Fname=~p~n",[Fname]),
    Data = get_file(Fname),
    Data.

get_file(Fname) ->
    {ok,Bin} = file:read_file(Fname),
    binary_to_list(Bin).

return_filename(ReqData,_Context) ->
    file_path(filename:join(wrq:path_tokens(ReqData))).

file_path(Fname) ->
    filename:join([tt_app:get_base_dir(), "priv/docroot", Fname]).
