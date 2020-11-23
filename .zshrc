setopt prompt_subst
DISABLE_MAGIC_FUNCTIONS="true"

# Git prompt information
GIT_PROMPT_SYMBOL=""
GIT_PROMPT_PREFIX=""
GIT_PROMPT_SUFFIX=""
GIT_PROMPT_AHEAD="%F{red}ANUM%"
GIT_PROMPT_BEHIND="%F{cyan}BNUM%"      
GIT_PROMPT_MERGING="%F{magenta}⚡︎"
GIT_PROMPT_UNTRACKED="%F{red}●"    
GIT_PROMPT_MODIFIED="%F{yellow}●"   
GIT_PROMPT_STAGED="%F{green}●"      

parse_git_branch() {
  # Show Git branch/tag, or name-rev if on detached head
  ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
  # Show different symbols as appropriate for various Git repository states
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""
  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi
  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi
  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi
  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi
  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi
  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

git_prompt_string() {
  local git_where="$(parse_git_branch)"
  # If inside a Git repository, print its branch and state
  [ -n "$git_where" ] && echo "$(parse_git_state) %F{green}⎇ ${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX "
  
}

RPROMPT='$(git_prompt_string)'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

PROMPT="%F{cyan}%1d %F{green}➤ %F{white}"

# ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# cd
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# go to places
alias root="cd /"
alias home="cd ~"
alias docs="cd ~/Documents"
alias downs="cd ~/Downloads"
alias desktop="cd ~/Desktop"
alias pics="cd ~/Pictures"
alias files="nautilus ."

# dotfiles
alias dots="cd ~/dotfiles"
alias dotfiles="cd ~/dotfiles"
alias scripts="cd ~/dotfiles/scripts"
alias config="cd ~/dotfiles/config"
alias configs="cd ~/dotfiles/config"

# Gnome
alias themes='cd /usr/share/themes'
alias icons='cd /usr/share/icons'
alias fonts='cd /usr/share/fonts'

# main 
alias c="clear"
alias q="exit"
alias s='sudo'
alias hosts='sudo vi /etc/hosts'
alias myip="curl -4 icanhazip.com"

# programs
alias v='sudo vim'
alias vi="sudo vim"
alias vim="sudo vim"

alias mysql='sudo mysql'
alias p='python3'
alias python='python3'

alias rmrf='sudo rm -rf'
alias psg='ps aux | grep'

# Make cp and mv print info, what was done
alias cp="cp -iv"
alias mv="mv -iv"
alias ln="ln -iv"

clear