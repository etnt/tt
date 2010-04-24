%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_scoring).
-export([gen_new_scores/2]).

-import(math, [log10/1]).

%% @doc Simple scoring model
%% @spec v1(Winner::integer(), Looser::integer()) -> {Winner,Looser}.

gen_new_scores(W, L) ->
    {NW, NL} = v1(W, L),
    [NW2] = io_lib:format("~.3f", [NW]),
    [NL2] = io_lib:format("~.3f", [NL]),
    {list_to_float(NW2), list_to_float(NL2)}.

v1(W, L) when W > L -> 
    {W + min(1, (1 / (W - L))), L - min(0.7, (1 / ((W - L) * 2)))};
v1(W, L) when W < L -> 
    {W + log10(max(10, (L - W) * 3)), L - log10(max(7, L - W))};
v1(W, L) -> 
    {W + 1, L - 1}.
    
min(A, B) ->
    case A < B of
	true  -> A;
	false -> B
    end.
	    
max(A, B) ->
    case A > B of
	true  -> A;
	false -> B
    end.
	    
