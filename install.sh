#!/bin/sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm ~/.zshrc
ln -s zshrc ~/.zshrc

git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
echo 'source ~/.autoenv/activate.sh' >> ~/.zshrc


echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export PROJECT_HOME=$HOME/Devel' >> ~/.zshrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.zshrc

mkdir ~/.pip/

cp pip.conf ~/.pip/


cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# 解决中文名文件问题
git config --global core.quotepath false 


git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -s
sudo pacman -U google

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
