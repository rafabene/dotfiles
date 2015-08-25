#!/bin/bash

os=`uname -s`

if [ $os = "Linux" ]; then
  os_system="LINUX"
fi

default() {
  if [ $os_system == "LINUX" ]; then
    zsh;
  else
    reattach-to-user-namespace -l zsh;
  fi
}

copy() {
  if [ $os_system == "LINUX" ]; then
    tmux show-buffer | xclip -selection clipboard -i;
  else
    reattach-to-user-namespace pbcopy;
  fi
}

paste() {
  if [ $os_system == "LINUX" ]; then
    xclip -selection clipboard -o | tmux load-buffer - && tmux paste-buffer;
  else
    reattach-to-user-namespace pbpaste;
  fi
}

if [ $1 = "copy" ]; then
  copy;
elif [ $1 = "paste" ]; then
  paste;
else
  default;
fi
