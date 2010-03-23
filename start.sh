#!/bin/sh
cd /home/tobbe/bin

. ./dep.inc

echo Starting tt...
erl 	-sname tt 	-pa ./ebin 	-s make all 	-eval "application:start(tt)"
