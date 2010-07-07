RicePaper is a tiny little command-line utility to post URLs to
InstantPaper. It also works as a Ruby library in a pinch also.

Installation

gem install ricepaper


Usage: ricepaper [options] "<url>" ["<url>" "<url>" ...]
    -u, --username [USER]            Username
    -p, --password [PASS]            Password
    -a, --authenticate               Only attempt to authenticate to Instapaper
    -t, --title [TITLE]              Optional title for instantpaper entry
    -d, --description [DESC]         Optional description for the article

