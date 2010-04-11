include dep.inc

compile: 
	(erl -make)

init: 
	mkdir ebin
	cp src/tt.app.src ebin/tt.app
	mkdir dep
	(cd dep; hg clone http://bitbucket.org/etnt/pure/; hg clone http://bitbucket.org/etnt/webmachine/)
	(cd dep/webmachine; make)

clean:
	rm -rf ./ebin/*.beam

