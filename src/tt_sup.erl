%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%% @end
%%%-------------------------------------------------------------------
-module(tt_sup).


-behaviour(supervisor).

%% External exports
-export([start_link/0, upgrade/0]).

%% supervisor callbacks
-export([init/1]).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec upgrade() -> ok
%% @doc Add processes if necessary.
upgrade() ->
    {ok, {_, Specs}} = init([]),

    Old = sets:from_list(
	    [Name || {Name, _, _, _} <- supervisor:which_children(?MODULE)]),
    New = sets:from_list([Name || {Name, _, _, _, _, _} <- Specs]),
    Kill = sets:subtract(Old, New),

    sets:fold(fun (Id, ok) ->
		      supervisor:terminate_child(?MODULE, Id),
		      supervisor:delete_child(?MODULE, Id),
		      ok
	      end, ok, Kill),

    [supervisor:start_child(?MODULE, Spec) || Spec <- Specs],
    ok.

%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->

    {ok, Dispatch} = file:consult(filename:join([tt_app:get_base_dir(), 
                                                 "priv", "dispatch.conf"])),

    Options = [{log_dir, tt_app:get_env(log_dir, "priv/log")},
               {enable_webmachine_logger, true},
               {enable_perf_logger, true},
               {dispatch, Dispatch}],

    webmachine_mochiweb:init(Options),
    tt_couchdb:init(),

    MochiOptions = [],
    Wspecs = [webmachine_mochiweb:worker_childspec(WebConfig) || 
                 WebConfig <- webmachine_mochiweb:setup_the_mochiweb_options(MochiOptions, 
                                                                             Dispatch)],

    {ok, {{one_for_one, 10, 10}, Wspecs}}.


