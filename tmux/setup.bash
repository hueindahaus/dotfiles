#!/bin/bash

# Install tmux
sudo apt install tmux

config_path="${XDG_CONFIG_HOME:-$HOME/.config}"/tmux
if test -d $config_path; then
	read -p "${config_path} already exists. Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi
mkdir -p $config_path

# Copy over tmux.conf
cp ./src/tmux.conf $config_path
