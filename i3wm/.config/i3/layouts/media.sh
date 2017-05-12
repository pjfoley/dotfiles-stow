#!/bin/bash
i3-msg "workspace media; append_layout ~/.config/i3/layouts/media.json"

i3-msg "workspace media; \
        exec urxvt -cd ~; \
        exec urxvt -cd ~; \
        exec urxvt -cd ~; \
        exec urxvt -cd ~"

sleep .5s

i3-msg "workspace media; \
  exec google-chrome-stable --new-window chrome://newtab; \
  exec urxvt -title "Playlist" -e ncmpcpp -s playlist &"

# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (google-chrome-stable chrome://newtab)
# (urxvt -title "Playlist" -e ncmpcpp -s playlist &)

