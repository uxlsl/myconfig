source /home/lin/work/myconfig/antigen.zsh

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


# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply


[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh

PATH=$PATH:/usr/local/go/bin/
export PATH

autoload -U compinit && compinit -u
