%%%-------------------------------------------------------------------
%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist
%%% @doc Bla bla
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(tt_scoring).
-export([v1/2]).

-import(math, [log10/1]).

%% @doc Simple scoring model
%% @spec v1(Winner::integer(), Looser::integer()) -> {Winner,Looser}.

v1(W,L) when W>L -> {W+(1/(W-L)), L-(1/((W-L)*2))};
v1(W,L) when W<L -> {W+log10((L-W)*3), L-log10(L-W)};
v1(W,L)          -> {W, L}.


    
