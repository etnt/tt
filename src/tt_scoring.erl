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


gen_new_scores(W, L) ->
    HasMorePoints = case W > L of
			true  -> winner;
			false -> loser
		    end,
    gen_new_scores(W, L, abs(W - L), HasMorePoints).

gen_new_scores(W, L, Diff, winner) when Diff >= 0 andalso Diff =< 12 ->
    {W + 8, L - 8};
gen_new_scores(W, L, Diff, loser) when Diff >= 0 andalso Diff =< 12 ->
    {W + 8, L - 8};
gen_new_scores(W, L, Diff, winner) when Diff >= 13 andalso Diff =< 37 ->
    {W + 7, L - 7};
gen_new_scores(W, L, Diff, loser) when Diff >= 13 andalso Diff =< 37 ->
    {W + 10, L - 10};
gen_new_scores(W, L, Diff, winner) when Diff >= 38 andalso Diff =< 62 ->
    {W + 6, L - 6};
gen_new_scores(W, L, Diff, loser) when Diff >= 38 andalso Diff =< 62 ->
    {W + 13, L - 13};
gen_new_scores(W, L, Diff, winner) when Diff >= 63 andalso Diff =< 87 ->
    {W + 5, L - 5};
gen_new_scores(W, L, Diff, loser) when Diff >= 63 andalso Diff =< 87 ->
    {W + 16, L - 16};
gen_new_scores(W, L, Diff, winner) when Diff >= 88 andalso Diff =< 112 ->
    {W + 4, L - 4};
gen_new_scores(W, L, Diff, loser) when Diff >= 8 andalso Diff =< 112 ->
    {W + 20, L - 20};
gen_new_scores(W, L, Diff, winner) when Diff >= 113 andalso Diff =< 137 ->
    {W + 3, L - 3};
gen_new_scores(W, L, Diff, loser) when Diff >= 113 andalso Diff =< 137 ->
    {W + 25, L - 25};
gen_new_scores(W, L, Diff, winner) when Diff >= 138 andalso Diff =< 162 ->
    {W + 2, L - 2};
gen_new_scores(W, L, Diff, loser) when Diff >= 138 andalso Diff =< 162 ->
    {W + 30, L - 30};
gen_new_scores(W, L, Diff, winner) when Diff >= 163 andalso Diff =< 187 ->
    {W + 2, L - 2};
gen_new_scores(W, L, Diff, loser) when Diff >= 163 andalso Diff =< 187 ->
    {W + 35, L - 35};
gen_new_scores(W, L, Diff, winner) when Diff >= 188 andalso Diff =< 212 ->
    {W + 1, L - 1};
gen_new_scores(W, L, Diff, loser) when Diff >= 188 andalso Diff =< 212 ->
    {W + 40, L - 40};
gen_new_scores(W, L, Diff, winner) when Diff >= 213 andalso Diff =< 237 ->
    {W + 1, L - 1};
gen_new_scores(W, L, Diff, loser) when Diff >= 213 andalso Diff =< 237 ->
    {W + 45, L - 45};
gen_new_scores(W, L, Diff, winner) when Diff >= 238 ->
    {W, L};
gen_new_scores(W, L, Diff, loser) when Diff >= 238 ->
    {W + 50, L - 50}.

