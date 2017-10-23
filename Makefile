src_files := $(shell find lib -name "*.ex")
test_files := $(shell find test -name "*.exs")

# .PHONY: all clean run iso

test: $(test_files)
	mix test

test-watch: $(test_files)
	echo $(test_files) $(src_files) | tr " " "\n" | entr mix test
	
run:
	mix run

run-watch:
	echo $(test_files) $(src_files) | tr " " "\n" | entr mix run