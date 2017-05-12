#!/bin/bash
i3-msg "workspace dev; append_layout ~/.config/i3/layouts/dev.json"

i3-msg "workspace dev; \
        exec urxvt -cd ~; \
        exec urxvt -cd ~"
sleep .5s
i3-msg "workspace dev; \
  exec google-chrome-stable --new-window chrome://newtab"

# (urxvt -cd ~ &)
# (urxvt -cd ~ &)
# (google-chrome-stable chrome://newtab)

