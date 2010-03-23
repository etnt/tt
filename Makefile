include dep.inc

compile: 
	(erl -make)

init: compile
	cp src/tt.app.src ebin/tt.app 

clean:
	rm -rf ./ebin/*.beam

