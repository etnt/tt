include dep.inc

compile: 
	(erl -make)

init: 
	mkdir ebin
	cp src/tt.app.src ebin/tt.app
	(cd dep/webmachine; make)

clean:
	rm -rf ./ebin/*.beam

