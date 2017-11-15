alias ls='ls --color=auto'
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
alias du_summary='du -h -d 1 . 2> /dev/null | sort -h'

alias hpacman='sudo cabal install --global --enable-documentation'
