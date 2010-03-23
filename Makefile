include dep.inc

compile: 
	(erl -make)

init: compile
	cp src/tt.app.src ebin/tt.app 
	(cd priv/docroot; mkdir js; cd js; ln -s ../../../dep/pure/libs/pure_packed.js .)

clean:
	rm -rf ./ebin/*.beam

