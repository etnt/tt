-module(tt_utils).

-export([json_return_object/2,
	 json_return_object/3,
	 set_content_type/1,
	 set_content_type/2,
	 return/3]).

%%
%% Json return object: {data:D, header:H, emsg:E}
%%
json_return_object(Header, Data) ->
    json_return_object(Header, Data, <<>>).

json_return_object(Header, Data, Emsg) ->
    rfc4627:encode({obj,[{header,Header},
                         {data,  Data},
                         {emsg,  Emsg}]}).
     

set_content_type(ReqData) ->
    set_content_type(ReqData, "text/javascript").
        
set_content_type(ReqData, ContentType) ->
    wrq:set_resp_headers([{"content-type",ContentType}], ReqData).

%% Generic function to generate the return data after a GET request
return({Header, Data}, ReqData, Context) ->
    {json_return_object(Header, Data), 
     tt_utils:set_content_type(ReqData, "application/json"),
     Context}.
