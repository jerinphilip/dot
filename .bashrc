#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


export EDITOR='vim'
alias gcc='gcc -Wall -Werror -Wuninitialized'
alias g++='g++ -Wall -Werror -Wuninitialized -std=c++14 -D EVIL_DEBUG'
alias die='shutdown -P now'
alias yaourt="yaourt --noconfirm"

alias glg++='g++ -I/usr/include/libdrm -lGLU -lGL -lglut -lglfw -lGLEW'
alias cvg++="g++ `pkg-config --cflags --libs opencv`"
alias gtk2gcc="gcc `pkg-config --cflags --libs gtk+-2.0`"
alias gtkgcc="gcc `pkg-config --cflags --libs gtk+-3.0`"
alias fucking='sudo'

alias pastebin='curl -F c=@- https://ptpb.pw'

export PATH="$PATH:/home/jerin/.gem/ruby/2.3.0/bin:/home/jerin/.cabal/bin"
export QT_STYLE_OVERRIDE=GTK+

function proxy_on {
    #printf -v no_proxy '%s,' 10.1.{1..255}.{1..255}
    export http_proxy="http://proxy.iiit.ac.in:8080"
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export no_proxy="localhost,127.0.0.1,.iiit.ac.in,"

    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
    export FTP_PROXY=$http_proxy
    export NO_PROXY=$no_proxy
}

function proxy_off {
    unset http_proxy https_proxy ftp_proxy no_proxy
    unset HTTP_PROXY HTTPS_PROXY FTP_PROXY NO_PROXY
}

proxy_on

export HISTCONTROL=ignoredups:avoiddups
export HISTSIZE=65536
export HISTFILESIZE=131076
shopt -s histappend

NPM_PACKAGES="${HOME}/.npm-packages"
PATH="$NPM_PACKAGES/bin:$PATH"
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
