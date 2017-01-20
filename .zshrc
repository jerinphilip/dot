# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory beep extendedglob nomatch notify
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jerin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#

PS1='[%n@%m %.]$ '

# Environment Settings
source ~/.shell/env.sh
# Proxy Settings
source ~/.shell/proxy.sh
proxy_on

source ~/.shell/aliases.sh
