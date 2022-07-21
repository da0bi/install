#!/bin/bash -i

# Installation script for my machines.
# Installs following packages/programs
# - build-essential
# - make
# - git
# - rclone
# - rust:   rustup
#           cargo
#           exa
#           fd-find
#           procs
#           ripgrep
#           texlab
#- python:  (sudo apt install):
#           python3-setuptools
#           python3-pip
#           python3-dev
#           jupyter-core
#           python3-numpy
#           python3-numpy-dev
#           python3-scipy
#           python3-matplotlib
#           (pip install):
#           ipython
#           jupyter
#               (numpy)
#               (scipy)
#               (matplotlib)
#           pandas
#           obspy
#           pyright
#- qgis
#- neovim
#- nodejs:  bash-language-server
#           tldr
#- packer (neovim package manager) 
#- gnome-tweak-tool
#- psysmon
#- pyrocko
#- wine
#- zotero
#
#
# @ daniel binder
# Copenhagen, 31.01.2022

printf '\n...INSTALLATION SCRIPT STARTED.\n'

##########
## .BASHRC edits - if necessary and .bashrc was not downloaded from github
##########
## export cargo path and add it to .bashrc
#echo '# add cargo path' >> ~/.bashrc
#echo 'export PATH=$PATH:$HOME/.cargo/bin' >> ~/.bashrc
## export ipython path and add it to .bashrc
#echo '# add ipython path' >> ~/.bashrc
#echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
## replace ls with exa in .bashrc
#echo '# replace ls with exa' >> ~/.bashrc
#echo "alias ll='exa -al --color=always --group-directories-first'" >> ~/.bashrc
#source $HOME/.bashrc
#
#printf '\n...BASHRC BLOCK FINISHED.\n'

#################################################
############# START INSTALLATIONS ###############
#################################################
# Update to latest package lists
sudo apt update
# cleaning
sudo apt autoremove --purge

#######
# BASIC packages
#######
sudo apt install build-essential
sudo apt install make
sudo apt install git
sudo apt install rclone
# To be able to use add-apt-repository you may need to install software-properties-common
sudo apt-get install software-properties-common
printf '\n...BASIC BLOCK FINISHED.\n'

######
# RUST installation(s)
######
# install rustup (https://rustup.rs)
sudo apt install curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# assure that ~/.cargo/bin is in your PATH
# update cargo to latest version
sudo apt install libssl-dev
cargo install cargo --force
# packages
cargo install exa
cargo install fd-find
cargo install procs
cargo install ripgrep
# nvim tex lsp
cargo install --git https://github.com/latex-lsp/texlab.git --locked
printf '\n...RUST BLOCK FINISHED.\n'

#########
# PYTHON3 packages
#########
sudo apt install python3-setuptools
sudo apt install python3-pip
sudo apt install python3-dev
sudo apt install jupyter-core
# global installation of following python packages - commented out for pip-installations
sudo apt-get install -y python3-numpy python3-numpy-dev python3-scipy python3-matplotlib
# assure that ~/.local/bin is in your PATH
# pip installations
pip install ipython
pip install Jupyter
#pip install numpy
#pip install scipy
#pip install matplotlib
pip install pandas
pip install obspy
pip install pipenv
# nvim python lsp
pip install pyright
printf '\n...PYTHON BLOCK FINISHED.\n'

########
# NODEJS installation of latest stable version
# following https://phoenixnap.com/kb/update-node-js-version
#######
sudo apt install nodejs
sudo apt install npm
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
# packages
# nvim bash lsp
sudo npm i -g bash-language-server
# tldr man pages
sudo npm install -g tldr
printf '\n...NODEJS BLOCK FINISHED.\n'

########
# NEOVIM installation(s)
#########
# Adding PPA to your system
sudo add-apt-repository ppa:neovim-ppa/stable
# update
sudo apt-get update
# instal
sudo apt install neovim
# packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# tex-, python-, and bash-lsp servers already installed within RUST, PYTHON, and NODEJS sections 
# install Nerd Font to display e.g. lualine symbols - follow installation guidelines in nerdfont.txt 
# installation of gnome tweak with all extensions (last line of apt installs) to be actually able to set
# the nerd font for the terminal
sudo add-apt-repository universe
sudo apt install gnome-tweak-tool
sudo apt install $(apt search gnome-shell-extension | grep ^gnome | cut -d / -f1)
# follow nerdfont.txt how to set nerd font with the gnome tweak tool
printf '\n...NEOVIM BLOCK FINISHED.\n'

##########
# QGIS installation
#########
# Adding PPA to your system 
sudo add-apt-repository ppa:ubuntugis/ppa
# update
sudo apt-get update
# install
sudo apt install qgis python3-qgis qgis-plugin-grass
printf '\n...QGIS BLOCK FINISHED.\n'

#########
# PSYSMON installation
#########
# install packages for pycairo
sudo apt install libcairo2-dev pkg-config
# clone psysmon into ~/Programs/psysmon
git clone https://github.com/da0bi/psysmon.git ~/Programs/psysmon
'''
##########
# with pip
##########
# install older numpy version - currently necessary for obspy
pip install numpy==1.21
# install wxpython with correct wheel for compilation from https://www.wxpython.org/pages/downloads
pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython
# add to python packages with pip install -e PFAD_ZUM_PSYSMON_ORDER_IN_DEM_SETUP.PY_LIEGT
pip install -e ~/Programs/psysmon
'''
#############
# with pipenv
#############
cd ~/Programs/psysmon/
# install older numpy version - currently necessary for obspy
pipenv install numpy==1.21
# install wxpython with correct wheel for compilation from https://www.wxpython.org/pages/downloads
pipenv run pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython
# install future package - somehow necessary for pipenv
pipenv install future
# add to python packages with pip install -e PFAD_ZUM_PSYSMON_ORDER_IN_DEM_SETUP.PY_LIEGT
pipenv install -e .
# change back to home
cd
#'''
# install maria db and follow psysmon.txt how to set it up
sudo apt install mariadb-server
printf '\n...PSYSMON BLOCK FINISHED.\n'

#########
# PYROCKO installation following
# https://github.com/pyrocko/pyrocko
#########
# clone github repository
git clone https://git.pyrocko.org/pyrocko/pyrocko.git ~/Programs/pyrocko
cd ~/Programs/pyrocko
# automated installation of all required packages
python3 install.py deps pip
# install with setup.py
#python3 install.py user
pip install -e .
cd
printf '\n...PYROCKO BLOCK FINISHED.\n'

######
# WINE installation following
# https://news.itsfoss.com/wine-7-0-release/
######
# Enable support for 32-bit architecture
sudo dpkg --add-architecture i386
# Download the official Wine repository key and add it
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
# Add the repository
sudo apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu focal main"
# update apt and install
sudo apt update && sudo apt install --install-recommends winehq-stable
# complete installation following wine.txt
printf '\n...WINE BLOCK FINISHED.\n'

########
# ZOTERO and JURISM installation following 
# https://github.com/retorquere/zotero-deb
########
#wget -qO- https://apt.retorque.re/file/zotero-apt/install.sh | sudo bash
curl -sL https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
sudo apt update
sudo apt install zotero
sudo apt install jurism
# sync zotero
# install zotero connector for firefox
# sync zotero
# install zotero connector for firefoxrintf '\n...ZOTERO BLOCK FINISHED.\n'

# Cleaning up
sudo apt autoremove --purge 
sudo apt clean

echo '...INSTALLATION SCRIPT FINISHED.'

