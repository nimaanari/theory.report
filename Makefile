.PHONY: run
run:
	bundler exec ruby neptune.rb build -o build -t theory
.PHONY: clean
clean:
	rm -rf planet.db build/
