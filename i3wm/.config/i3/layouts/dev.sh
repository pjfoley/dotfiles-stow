#!/bin/bash
i3-msg "workspace dev; append_layout ~/.config/i3/layouts/dev.json"

i3-msg "workspace dev; \
        exec i3-sensible-terminal -d ~; \
        exec i3-sensible-terminal -d ~"
sleep .5s
i3-msg "workspace dev; \
  exec google-chrome-stable --new-window chrome://newtab"

# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (google-chrome-stable chrome://newtab)

