%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Setup of the Inets httpd server.
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_inets).
-export([start/0, stop/0, do/1]).
-include("httpd.hrl").

-define(DEFAULT_PORT, 8080).

start() ->
    inets_start().

stop() ->
    RegName = list_to_atom("httpd_instance_sup_"++
                           integer_to_list(?DEFAULT_PORT)),
    inets_stop(whereis(RegName)).
   
inets_start() ->
    inets:start(),
    {ok, CWD} = file:get_cwd(),
    io:format("~p(~p): document_root = ~p~n", [?MODULE,?LINE,CWD++"/priv/docroot"]),
    {ok, Pid} = 
        inets:start(httpd, 
                    [{port, ?DEFAULT_PORT},
                     {server_name, hostname()},
                     {server_root, CWD},
                     {document_root, CWD++"/priv/docroot"},
                     {directory_index, ["index.html"]},
                     {modules, [mod_alias, mod_get, mod_head, ?MODULE]}
                    ]),
    link(Pid),
    {ok, Pid}.

inets_stop(Pid) ->
    inets:stop(httpd, Pid).

hostname() ->
    {ok,Host} = inet:gethostname(),
    Host.


do(Info) ->
    try dodo(Info)
    catch _:Err -> io:format("Error(~p): ~p~n", 
                             [Err, erlang:get_stacktrace()]) 
    end.

-define(HTTP_NOT_FOUND, 404).

dodo(Info) ->
    case proplists:get_value(status, Info#mod.data) of
        %% A status code has been generated!
        {?HTTP_NOT_FOUND, _PhraseArgs, _Reason} ->
            io:format("~p(~p): status = ~p~n", [?MODULE,?LINE,404]),
            case Info#mod.request_uri of
                "/rest"++Rest ->
                    %%[{response,{response,Head,Body}}]
                    io:format("~p(~p): uri = ~p~n", [?MODULE,?LINE,Info#mod.request_uri]),
                    {proceed, [{response,{200,test_page()}}]};
                _X ->
            io:format("~p(~p): response = ~p~n", [?MODULE,?LINE,_X]),
                    {proceed, Info#mod.data}
            end;
	%% A response has been generated or sent!
	_Response ->
            {proceed, Info#mod.data}
    end.

test_page() ->
    "<html><head><title>Test Page</title></head><body>This is a Test Page</body></html>".

