%%%-------------------------------------------------------------------
%%% @author Jordi Chacon <jordi.chacon@gmail.com>
%%% @copyright (C) 2010, Jordi Chacon
%%% @doc Module that represents the user resource
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_users_resource).
-export([init/1]).
-export([allowed_methods/2,
%	 resource_exists/2,
	 content_types_provided/2,
	 content_types_accepted/2,
	 create_user/2,
         post_is_create/2,
	 return_data/2,
         create_path/2]).

-include_lib("webmachine/include/webmachine.hrl").


init(Context) -> {ok, Context}.

allowed_methods(ReqData, Context) ->
    {['GET', 'PUT', 'POST'], ReqData, Context}.

%% resource_exists(ReqData, Context) ->
%%     Path = wrq:disp_path(ReqData),
%%     case soma of 
%% 	{true, _} ->
%% 	    {true, ReqData, Context};
%% 	_ ->
%%             case Path of
%%                 "p" -> {true, ReqData, Context};
%%                 _ -> {false, ReqData, Context}
%%             end
%%     end.

content_types_provided(ReqData, Context) ->
    {[{"text/javascript",         return_data}
      ,{"application/javascript", return_data}
     ], ReqData, Context}.

return_data(ReqData, Context) ->
    case wrq:disp_path(ReqData) of
	"" ->
	    Data = tt_utils:json_return_object(
		     <<"">>, {obj, [{users, tt_couchdb:users()}]}),
	    {Data, 
	     tt_utils:set_content_type(ReqData, "application/json"), 
	     Context};
	_ ->
	    io:format("~p~n", [wrq:disp_path(ReqData)])
    end.

%%
%% Functions that handle the creation of a new user
%%
content_types_accepted(ReqData, Context) ->
    CT = wrq:get_req_header("content-type", ReqData),
    {MT, _Params} = webmachine_util:media_type_to_detail(CT),
    {[{MT, create_user}], ReqData, Context}.

post_is_create(ReqData, Context) ->
    {true, ReqData, Context}.

create_path(ReqData, Context) ->
    case mochiweb_util:parse_qs(wrq:req_body(ReqData)) of
	[{"nick", Nick}] ->
	    {Nick, ReqData, Context};
        _ -> 
	    {undefined, ReqData, Context}
    end.

create_user(ReqData, Context) ->
    Nick = wrq:disp_path(ReqData),
    Users = tt_couchdb:users(),
    case nick_already_used(Nick, Users) of
        false ->
	    tt_couchdb:store_doc([{"type",<<"user">>},
				  {"nick",list_to_binary(Nick)},
				  {"score",0}]),
            {true, ReqData, Context};
        true ->
	    {{error, "already_exists"}, ReqData, Context}
    end.   

nick_already_used(Nick, [{obj,[{"nick", N},_]}|T]) ->
    case binary_to_list(N) of
	Nick -> true;
	_    -> nick_already_used(Nick, T)
    end;
nick_already_used(_Nick, []) ->
    false.
	    
