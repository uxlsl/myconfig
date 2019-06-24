source /home/lin/work/myconfig/antigen.zsh
source $HOME/.local/bin/virtualenvwrapper.sh
source ~/.autoenv/activate.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle zsh-users/zsh-autosuggestions

antigen bundle Tarrasch/zsh-autoenv

antigen bundle supercrabtree/k

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

PATH=$PATH:/usr/local/go/bin/

export PYTHONIOENCODING='utf8'
export PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias xclip='xclip -selection clipboard'
alias open=xdg-open
alias docker-gc='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc'

alias -s gz='tar -xzvf' # 快速打开gz文件
alias -s bz2='tar -xjvf' # 快速打开bz2文件
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias www="python -m SimpleHTTPServer 8000"

export EDITOR=vim

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U compinit && compinit -u
