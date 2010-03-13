test:
	erl -noshell -sname forge -s xpdojo test_files . -s init stop

server:
	erl -noshell -sname forge -eval 'testing_server:start(".", "log.txt").' &
	tail -f log.txt
