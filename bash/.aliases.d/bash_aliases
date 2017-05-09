# GNU ls color
ls --color=auto > /dev/null 2>&1 && alias ls='ls --color=auto'

# Only some grep supports `--color=auto'
if echo x | grep --color=auto x >/dev/null 2>&1; then
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias df='df -h'
alias du='du -h'

{ if ! command -v open && command -v xdg-open; then
  alias open='xdg-open'
fi } >/dev/null

command -v free > /dev/null && \
  alias free='free -h'

alias lf='ls -Gl | grep --color=auto ^d' #Only list directories
alias lsd='ls -Gal | grep --color=auto ^d' #Only list directories, including hidden ones

# Show hidden files only
alias l.='ls -d .* --color=auto'

# Jump back n directories at a time
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# Make and cd into directory
function mcd() {
  mkdir -p "$1" && cd "$1";
}
