.PHONY: build
build:
	bundler exec ruby neptune.rb build theory.ini -o build -t theory -n theory.db
.PHONY: install
install:
	bundler install
.PHONY: clean
clean:
	rm -rf theory.db build/
