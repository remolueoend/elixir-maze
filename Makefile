src_files := $(wildcard lib/*.ex)
test_files := $(wildcard test/*.exs)

# .PHONY: all clean run iso

test: $(test_files)
	mix test

test-watch: $(test_files)
	echo $(test_files) $(src_files) | tr " " "\n"  | entr mix test