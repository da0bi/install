#!/bin/sh

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

echo -e '\n...INSTALLATION SCRIPT STARTED.\n'

#########
# .BASHRC edits - if necessary
#########
# export cargo path and add it to .bashrc
echo -e '\n# add cargo path' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/.cargo/bin' >> ~/.bashrc
# export ipython path and add it to .bashrc
echo -e '\n# add ipython path' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
# replace ls with exa in .bashrc
echo -e '\n# replace ls with exa' >> ~/.bashrc
echo 'alias ll='exa -al --color=always --group-directories-first'' >> ~/.bashrc
echo -e '\n...BASHRC BLOCK FINISHED.\n'

#################################################
############## START INSTALLATIONS ##############
#################################################
# Update to latest package lists
sudo apt update

#######
# BASIC installations following 01_apt_install.txt
#######
sudo apt install build-essential
sudo apt install make
sudo apt install git
sudo apt install rclone
echo -e '\n...BASIC BLOCK FINISHED.\n'

######
# RUST installation following 02_rust.txt
######
# install rustup (https://rustup.rs)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# update cargo to latest version
cargo install cargo --force
# install packages
cargo install exa
cargo install fd-find
cargo install procs
cargo install ripgrep
# nvim tex lsp
cargo install --git https://github.com/latex-lsp/texlab.git --locked
echo -e '\n...RUST BLOCK FINISHED.\n'

#########
# PYTHON3 packages installation following 03_python.txt
#########
sudo apt install python3-setuptools
sudo apt install python3-pip
sudo apt install python3-dev
sudo apt install jupyter-core
# global installation of following python packages - commented out for pip-installations
sudo apt-get install -y python3-numpy python3-numpy-dev python3-scipy python3-matplotlib
# pip installations
pip install ipython
pip install Jupyter
#pip install numpy
#pip install scipy
#pip install matplotlib
pip install pandas
pip install obspy
# nvim python lsp
pip install pyright
echo -e '\n...PYTHON BLOCK FINISHED.\n'

#########
# ADD PPA for QGIS and NEOVIM and install, following 04_ppa.txt
#########
# To be able to use add-apt-repository you may need to install software-properties-common
sudo apt-get install software-properties-common
# Adding PPA to your system, update and install 
sudo add-apt-repository ppa:ubuntugis/ppa
sudo add-apt-repository ppa:neovim-ppa/stable
# update
sudo apt-get update
# install
sudo apt install qgis python-qgis qgis-plugin-grass
sudo apt install neovim
echo -e '\n...PPA BLOCK FINISHED.\n'

########
# NODEJS installation of latest stable version, following 05_nodejs.txt
# following https://phoenixnap.com/kb/update-node-js-version
#######
sudo apt install nodejs
npm cache clean -f
npm install -g n
sudo n stable
# installations
# nvim bash lsp
sudo npm i -g bash-language-server
# tldr man pages
sudo npm install -g tldr
echo -e '\n...NODEJS BLOCK FINISHED.\n'

########
# NEOVIM installations, following 06_nvim.txt
########
# packer package manager
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# tex-, python-, and bash-lsp servers already installed within RUST, PYTHON, and NODEJS sections 
# install Nerd Font to display lualine symbols - follow installation guidelines in 06_nvim.txt 
# install gnome tweak with all extensions (last line of apt installs) to actually apply nerd font in the terminal
sudo add-apt-repository universe
sudo apt install gnome-tweak-tool
sudo apt install $(apt search gnome-shell-extension | grep ^gnome | cut -d / -f1)
# follow 06_nvim.txt how to set nerd font in gnome tweak tool
echo -e '\n...NEOVIM BLOCK FINISHED.\n'

#########
# PSYSMON installation following 07_psysmon.txt
#########
# install packages for pycairo
sudo apt install libcairo2-dev pkg-config
# install older numpy version (as long as there is no virtual environment like e.g. pipenv)
pip install numpy==1.21
# install wxpython with correct wheel for compilation
pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython
# clone psysmon into ~/Programs/
git clone https://github.com/stefanmaar/psysmon.git ~/Programs
# add to python packages with 'pip install -e PFAD_ZUM_PSYSMON_ORDER_IN_DEM_SETUP.PY_LIEGT'
pip install -e ~/Programs/psysmon
# install maria db and follow 07_psysmon.txt how to set it up
sudo apt install mariadb-server
echo -e '\n...PSYSMON BLOCK FINISHED.\n'

#########
# PYROCKO installation following 08_pyrocko.txt 
#########
# clone github repository for the squirrel branch
git clone -b squirrel https://git.pyrocko.org/pyrocko/pyrocko.git ~/Programs
cd ~/Programs/pyrocko
# automated installation of all required packages
sudo python3 install_prerequisites.py
# install with setup.py
sudo python3 setup.py install
echo -e '\n...PYROCKO BLOCK FINISHED.\n'

######
# WINE installation following 09_wine.txt
# and after https://news.itsfoss.com/wine-7-0-release/
######
# Enable support for 32-bit architecture
sudo dpkg --add-architecture i386
# Download the official Wine repository key and add it
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
# Add the repository
sudo apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu focal main"
# update apt and install
sudo apt update && sudo apt install --install-recommends winehq-stable
# complete installation following 07_wine.txt
echo -e '\n...WINE BLOCK FINISHED.\n'

########
# ZOTERO and JURISM installation following 10_zotero.txt
########
wget -qO- https://apt.retorque.re/file/zotero-apt/install.sh | sudo bash
sudo apt update
sudo apt install zotero
sudo apt install jurism
echo -e '\n...ZOTERO BLOCK FINISHED.\n'

echo '...INSTALLATION SCRIPT FINISHED.'

