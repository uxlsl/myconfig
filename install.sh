#!/bin/sh
set -e

get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}

lsb_dist=$( get_distribution )
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
case "$lsb_dist" in
	ubuntu|debian)
		apt-get update
		install_cmd='apt-get install -y'
	;;
	centor|fedora)
		sudo yum install -y zlib-devel openssl-devel libxslt-devel libxslt libxml2 libxml2-devel \
    sqlite-devel readline-devel xz-devel  bzip2-devel sqlite-devel
		sudo yum install -y epel-release python-devel
		sudo yum install -y ncurses-devel
		sudo dnf install -y redhat-rpm-config
		sudo yum groupinstall -y "Development Tools"
		sudo yum install -y gcc-c++
		sudo dnf install -y ruby-devel
		sudo dnf install -y ncdu  
		sudo dnf install -y fd-find
		sudo dnf module install bat  -y
		sudo dnf install -y gnome-tweak-tool
		sudo dnf install zeal # 查文档用
		sudo dnf install i3 # 查文档用
		sudo dnf install feh # 修改i3配置
		sudo dnf install neofetch # 使用neofetch获取信息
		sudo flatpak install flathub com.github.calo001.fondo # 看图片用
		sudo flatpak install flathub io.dbeaver.DBeaverCommunity  # 数据库客户端
		install_cmd='yum install -y'
	;;
	arch)
		install_cmd='pacman -S'
	;;
esac 

if [[ $EUID -ne 0 ]]; then
	$install_cmd="sudo $install_cmd"
fi

echo $install_cmd

$install_cmd git python-pip zsh curl tmux golang

pip install virtualenvwrapper --user

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rm ~/.zshrc
cp zshrc ~/.zshrc

git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
echo 'source ~/.autoenv/activate.sh' >> ~/.zshrc


echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export PROJECT_HOME=$HOME/Devel' >> ~/.zshrc
echo 'source ./.local/bin/virtualenvwrapper.sh' >> ~/.zshrc

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

# 终端看使用
#npm install -g vtop
git clone https://github.com/vim/vim.git
cd vim &&./configure --with-features=big  --enable-pythoninterp=yes && make && make install
cd ..
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
# 让一般用户使用docker
sudo usermod -aG docker lin

pip install youdao --user
# 使用cow 自动切换代理
go get github.com/cyfdecyf/cow
=======
#godoc -http=:6060

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
gem install redis-stat

# 安装clipboard插件
git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
git clone https://github.com/enkore/j4-dmenu-desktop.git
cd j4-dmenu-desktop &&(
cmake .
make
sudo make install
)

git clone git://github.com/wting/autojump.git && cd autojump && python install.py
