.PHONY: build
build:
	bundler exec ruby neptune.rb build theory.ini -o build -t theory
.PHONY: install
install:
	bundler install
.PHONY: clean
clean:
	rm -rf planet.db theory.db build/
