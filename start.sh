#!/bin/sh

. ./dep.inc

echo Starting tt...
erl -sname tt \
    -pa ./ebin 	\
    -pa ${WEBMACHINE_DIR}/ebin 	\
    -pa ${MOCHIWEB_DIR}/ebin 	\
    -boot start_sasl \
    -s make all \
    -eval "application:start(tt)"
