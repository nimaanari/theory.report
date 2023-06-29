# Theory of Computing Report

This repository hosts the configuration and scripts required to build the aggregator for theory of computing blogs/feeds at [theory.report](https://theory.report), which aims to be an alternative to the [TCS Blog Aggregator](https://github.com/abhatt/aggregator).

The [build script](.github/workflows/build.yml) is run by GitHub Actions to fetch the feeds every hour, and the built website itself is hosted on GitHub Pages. All of the infrastructure needed to build/host is provided by GitHub.

## List of Feeds

Pull requests to update the list of feeds are welcome. Please only make changes to [theory.ini](theory.ini).
