#!/usr/bin/env bash

#Run ansible
ansible-playbook --ask-become-pass -i ansible/inventory ansible/setup-dotfiles.yaml --extra-vars "dotfilespath=`pwd`"

#Run zsh
env zsh
source ~/.zshrc
