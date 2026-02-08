#!/bin/bash

# Install nvim
read -p "Do you want to install all necessary binaries (y/n)? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
# sudo snap install --beta nvim --classic
sudo apt install zip
sudo apt install ripgrep
fi
