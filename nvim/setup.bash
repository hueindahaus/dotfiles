#!/bin/bash
# Installs rust and cargo. I want to mainly access cargo to install treesitter-cli :(
curl https://sh.rustup.rs -sSf | bash -s -- -y 

# Install nvim
read -p "Do you want to install all necessary binaries (y/n)? " -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
# sudo snap install --beta nvim --classic
sudo apt install zip
sudo apt install ripgrep # Used by telescope grep
sudo apt install fd-find # Used by telescope
cargo install tree-sitter-cli
curl -fsSL https://opencode.ai/install | bash
fi
