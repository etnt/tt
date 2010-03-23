%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_app).
-export([start/2, stop/1, get_env/2, top_dir/0]).
-behavior(application).

start(_, _) -> 
    case tt_sup:start_link() of
	{ok, Pid} -> 
	    {ok, Pid};
	Error ->
	    Error
    end.


stop(_) -> 
    ok.

get_env(Key, Default) ->
    case application:get_env(tt, Key) of
        {ok, Value} -> Value;
        _           -> Default
    end.

top_dir() ->
    filename:join(["/"|lists:reverse(tl(lists:reverse(string:tokens(filename:dirname(code:which(?MODULE)),"/"))))]).

