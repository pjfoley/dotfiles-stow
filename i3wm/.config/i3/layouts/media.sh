#!/bin/bash
i3-msg "workspace media; append_layout ~/.config/i3/layouts/media.json"

i3-msg "workspace media; \
        exec i3-sensible-terminal -d ~; \
        exec i3-sensible-terminal -d ~; \
        exec i3-sensible-terminal -d ~; \
        exec i3-sensible-terminal -d ~"

sleep .5s

i3-msg "workspace media; \
  exec google-chrome-stable --new-window chrome://newtab; \
  exec i3-sensible-terminal --title "Playlist" -e ncmpcpp -s playlist &"

# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (google-chrome-stable chrome://newtab)
# (urxvt -title "Playlist" -e ncmpcpp -s playlist &)

