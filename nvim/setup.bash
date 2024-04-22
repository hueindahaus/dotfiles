#!/bin/bash

# Install nvim
sudo snap install --beta nvim --classic
sudo apt install clang
sudo apt install zip
sudo apt install python3
sudo apt install python3-pip
sudo apt install python3.10-venv

# Copy over configs
config_path="${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
if test -d $config_path; then
	read -p "${config_path} already exists. Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi
mkdir -p $config_path
cp ./src/init.lua $config_path
mkdir -p $config_path/lua
cp -r ./src/lua $config_path/lua


