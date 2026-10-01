# Theory of Computing Report

This repository hosts the configuration and scripts required to build the aggregator for theory of computing blogs/feeds at [theory.report](https://theory.report), which aims to be an alternative to the [TCS Blog Aggregator](https://github.com/abhatt/aggregator).

The [build script](.github/workflows/build.yml) is run by GitHub Actions to fetch the feeds every hour, and the built website itself is hosted on GitHub Pages. All of the infrastructure needed to build/host is provided by GitHub.

## List of Feeds

Pull requests to update the list of feeds are welcome. Please only make changes to [theory.ini](theory.ini).

## Recent-post limits

Each arXiv category in `theory.ini` requests the latest 1,000 entries by submission
date. The HTML page, RSS feed, and Atom feed each include the latest
200 posts across all feeds. Keep the output limits in
`theme/index.html.erb`, `theme/rss.xml.erb`, and `theme/atom.xml.erb` in sync.

The larger input window preserves coverage during conference submission surges,
with one request per category per fetch. The smaller output window limits page
size and the number of articles updated by the display controls. It does not
remove cached posts from the database. The 1,000-entry requests stay within the
[arXiv API's recommended result size](https://info.arxiv.org/help/api/user-manual.html#3112-start-and-max_results-paging).
The existing first-version filter still applies, so fewer than 1,000 entries per
category may be retained. This is a larger recent-post window, not a complete
archive: upstream truncation, version filtering, and the combined output cap
still limit coverage.
