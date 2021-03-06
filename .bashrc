#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
PS1="[\u@\h \W]\$ "



source ~/.shell/aliases.sh
export PATH="$PATH:/home/jerin/.gem/ruby/2.3.0/bin:/home/jerin/.cabal/bin"
export QT_STYLE_OVERRIDE=GTK+


source ~/.shell/proxy.sh
source ~/.shell/env.sh
source ~/.shell/dual_screen.sh
proxy_on

# HISTORY
export HISTCONTROL=ignoredups:avoiddups
export HISTSIZE=65536
export HISTFILESIZE=131076
shopt -s histappend


# Temporary, Stupid Optimization Methods
export PATH="$PATH:/home/jerin/build/cplex/cplex/bin/x86-64_linux/"
export PATH="$PATH:/home/jerin/Downloads/ampl/"

export JAVA_HOME="/usr/lib/jvm/default/include"
