%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_resource).
-export([init/1, to_html/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

to_html(ReqData, State) ->
    {index(), ReqData, State}.

index() ->
    <<"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\">
  <head>
    <title>Table Tennis Scoring Board</title>
    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=iso-8859-1\" />

    <!-- Javascript -->
    <script src='/assets/js/jquery-1.4.2.min.js' type='text/javascript' charset='utf-8'></script>
    <script src='/assets/js/pure_packed.js' type='text/javascript' charset='utf-8'></script>
    <script src='/assets/js/tt.js' type='text/javascript' charset='iso-8859-1'></script>


    <!-- CSS -->
    <link rel=\"stylesheet\" href=\"/assets/css/blueprint/screen.css\" type=\"text/css\" media=\"screen, projection\" />
    <link rel=\"stylesheet\" href=\"/assets/css/blueprint/print.css\" type=\"text/css\" media=\"print\" />    
    <!--[if IE]><link rel=\"stylesheet\" href=\"/assets/css/blueprint/ie.css\" type=\"text/css\" media=\"screen, projection\"><![endif]-->
    <link rel=\"stylesheet\" href=\"/assets/css/tt.css\" type=\"text/css\" media=\"screen, projection\" />

    <link rel='shortcut icon' href='/assets/images/favicon.ico' />
  </head>
  <body>
<div id=\"wrapper\">
  <h1><em>PING PONG at KLARNA</em></h1>
  <div id=\"topcon\">
    <div id=\"topcon-inner\">
      <h2>Sign up</h2>
      <p>Hi Klarna employee and welcome to our ping pong table tracking system!</p>
      <p>Sign up, start registering your ping pong matches and climb to the top of the ranking!</p>
      <form id=\"signform\">
      <div>
	<label for=\"nick\">Nick:</label>
	<input type=\"text\" id=\"nick\" name=\"nick\" />
        <input type=\"submit\" name=\"g\" value=\"Sign up!\" id=\"g\" />
      </div>
      </form>
    </div>
  </div>
  <div id=\"content\">
    <div id=\"body\">
      <div class=\"box\" id=\"news\">
        <div class=\"box-t\">
          <div class=\"box-r\">
            <div class=\"box-b\">
              <div class=\"box-l\">
                <div class=\"box-tr\">
                  <div class=\"box-br\">
                    <div class=\"box-bl\">
                      <div class=\"box-tl\">
                        <h2>NEW MATCH</h2>
                        <form id=\"regform\">
                           <div class=\"result\">
                              <div class=\"resultselect\">
                                  <h3 id=\"h3winner\">Winner</h3>
		                  <select class=\"usersselect\" id=\"winner\" name=\"winner\">
		                  <option class=\"users\" value=\"\" ></option>
		                  </select>
                              </div>
                              <div class=\"scoreboard\">
                                  <input class=\"figures\" maxlength=\"2\" type=\"text\" id=\"wfigures\" name=\"wfigures\" />
                              </div>
                           </div>
                           <div id=\"dash\">
                                  <span class=\"mdash\">&mdash;</span></td>
                           </div>
                           <div class=\"result\">
                              <div class=\"scoreboard\">
                                  <input class=\"figures\" maxlength=\"2\" type=\"text\" id=\"lfigures\" name=\"lfigures\" />
                              </div>
                              <div class=\"resultselect\">
                                  <h3 id=\"h3loser\">Loser</h3>
		                  <select class=\"usersselect\" id=\"looser\" name=\"looser\">
		                  <option class=\"users\" value=\"\" ></option>o
		                  </select>
                              </div>
                           </div>
                           <div id=\"submit\">
                             <input type=\"submit\" name=\"g\" value=\"Submit\" id=\"g\" />
                           </div>
                         </form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class=\"box\" id=\"hits\">
        <div class=\"box-t\">
          <div class=\"box-r\">
            <div class=\"box-b\">
              <div class=\"box-l\">
                <div class=\"box-tr\">
                  <div class=\"box-br\">
                    <div class=\"box-bl\">
                      <div class=\"box-tl\" id=\"nranking\">
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class=\"box\" id=\"new\">
        <div class=\"box-t\">
          <div class=\"box-r\">
            <div class=\"box-b\">
              <div class=\"box-l\">
                <div class=\"box-tr\">
                  <div class=\"box-br\">
                    <div class=\"box-bl\">
                      <div class=\"box-tl\" id=\"nmatches\">
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class=\"clear\"> </div>
    </div>
    <div id=\"footer\">
      <ul>
      </ul>
    </div>
  </div>
</div>
  </body>
</html>
">>.
