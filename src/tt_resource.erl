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
   <div id=\"container\">

    <div id=\"nav\">
      <a href=\"#\" id=\"nranking\" class=\"nav_link\">Ranking</a>
      <span class=\"nav_sep\">|</span>
      <a href=\"#\" id=\"nregister\" class=\"nav_link\">Register</a>
      <span class=\"nav_sep\">|</span>
      <a href=\"#\" id=\"nscores\" class=\"nav_link\">Scores</a>
      <span class=\"nav_sep\">|</span>
      <a href=\"#\" id=\"nabout\" class=\"nav_link\">About</a>
    </div>
    <hr size=\"1\" class=\"hr\" />

    <div id=\"main\">
      <h1 id=\"header\"></h1>

      <!-- HTML templates -->
      <table id=\"ranking\" class=\"template\">
	<tr>
	  <th><span class=\"name\">Name</span></td>
	  <th><span class=\"score\">Score</span></td>
	</tr>
        <tbody id=\"scoredata\">
   	  <tr class=\"scoreentry\">
	    <td><span class=\"name\"></span></td>
	    <td><span class=\"score\"></span></td>
	  </tr>
        </tbody>
      </table>

    </div>
   </div>
  </body>
</html>
">>.
