%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_app).

-export([start/2
         , stop/1
         , get_env/2
         , get_base_dir/0
         , get_base_dir/1
         , local_path/1
         , local_path/2
        ]).

-behavior(application).

%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for tt.
start(_, _) -> 
    application:start(inets),
    application:start(crypto),
    application:start(webmachine),
    tt_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for tt.
stop(_) -> 
    ok.


get_env(Key, Default) ->
    case application:get_env(tt, Key) of
        {ok, Value} -> Value;
        _           -> Default
    end.

%% @spec get_base_dir() -> string()
%% @doc Return the application directory for this application. Equivalent to
%%      get_base_dir(?MODULE).
get_base_dir() ->
    get_base_dir(?MODULE).

%% @spec get_base_dir(Module) -> string()
%% @doc Return the application directory for Module. It assumes Module is in
%%      a standard OTP layout application in the ebin or src directory.
get_base_dir(Module) ->
    {file, Here} = code:is_loaded(Module),
    filename:dirname(filename:dirname(Here)).

%% @spec local_path([string()], Module) -> string()
%% @doc Return an application-relative directory from Module's application.
local_path(Components, Module) ->
    filename:join([get_base_dir(Module) | Components]).

%% @spec local_path(Components) -> string()
%% @doc Return an application-relative directory for this application.
%%      Equivalent to local_path(Components, ?MODULE).
local_path(Components) ->
    local_path(Components, ?MODULE).

