What This Is
============

RSSReader is a command-line based RSS reader for Mac OS. This is just a backup of an old class project, and will not be of interest to anybody.

Features
========

The RSSReader fetches and parses any RSS or Atom feed, prints the URL of the feed, the status of the parsing, the title of the feed, and the title, a small excerpt, and publication date of the latest items from the feed. RSSReader can handle plain text and CDATA text, and it gracefully handles broken URL's or other parse errors, such as poorly formatted XML.

In settings.plist, you will find 4 feeds. The first feed is an RSS feed, the second is an Atom feed, the third demonstrates what happens when a feed is disabled, and the fourth demonstrates what happens when an improper URL is provided.

The length of the excerpt can be configured for each feed in settings.plist by adjusting DescMax to the number of desired characters in the excerpt.