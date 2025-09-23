#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# Allow users to override command-line options
if [[ -f $XDG_CONFIG_HOME/chrome-star-flags.conf ]]; then
    CHROME_USER_FLAGS="$(grep -v '^#' $XDG_CONFIG_HOME/chrome-star-flags.conf)"
fi

progname=$(basename "$0") || exit 1

if [ "$progname" = "google-chrome-stable" ]; then
    variant="chrome"
    progname="google-chrome"
else
    variant="${progname#google-}"
fi

# Launch
exec "/opt/google/$variant/$progname" $CHROME_USER_FLAGS "$@"
