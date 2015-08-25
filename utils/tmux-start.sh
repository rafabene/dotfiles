#!/bin/bash
export PATH=$PATH:/usr/local/bin

# abort if we're already inside a TMUX session
[[ "$TMUX" == "" ]] || exit 0

clear

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
options=("zsh" "New session" $(tmux list-sessions -F "#S" 2> /dev/null) )

echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
  case $opt in
    "New session")
      read -p "Enter new session name: " session_name
      tmux new -s "$session_name"
      break
      ;;
    "zsh")
      zsh
      break;;
    *)
      tmux attach-session -t $opt
      break
      ;;
  esac
done