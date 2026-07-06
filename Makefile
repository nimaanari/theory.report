.PHONY: build
build:
	bundle exec ruby neptune.rb build theory.ini -o build -t theory -n theory.db
.PHONY: install
install:
	bundle install
.PHONY: clean
clean:
	rm -rf theory.db build/
