#!/bin/sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm ~/.zshrc
cp zshrc ~/.zshrc

git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
echo 'source ~/.autoenv/activate.sh' >> ~/.zshrc


echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export PROJECT_HOME=$HOME/Devel' >> ~/.zshrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.zshrc

mkdir ~/.pip/

cp pip.conf ~/.pip/


# 解决中文名文件问题
git config --global core.quotepath false 


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 安装mitmproxy cert
certutil -d sql:$HOME/.pki/nssdb -A -t C -n mitmproxy -i ~/.mitmproxy/mitmproxy-ca-cert.pem

# 安装zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 安装CloudClip
#git clone https://github.com/skywind3000/CloudClip.git

pip install better_exceptions --user

# 安装xflux-gui
# https://github.com/xflux-gui/fluxgui

mkdir -p ~/.config/matplotlib/
cp matplotlibrc ~/.config/matplotlib/
rm ~/.cache/matplotlib
mkdir -p ~/.local/share/fonts
cp SimHei.ttf ~/.local/share/fonts
mkdir ~/.fonts/
cp SimHei.ttf ~/.fonts

# 安装 man 的简化版，参考工具tldr 
pip install tldr --user

# 安装mackup 备份linux,和还原linux
pip install mackup  --user
# 方便一眼看到当前系统的状态
pip install glances --user

# 使用repren重命名文件
pip install repren --user

# 使用ngrok做反回代理
git clone git@github.com:inconshreveable/ngrok.git
cd ngrok && make

# ./bin/ngrokd -domain linsl2018.top -httpAddr  -httpsAddr

# 安装ranger 
git clone https://github.com/vim/vim.git
cd vim &&./configure --with-features=big  --enable-pythoninterp=yes && make && make install

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
