# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="fino-time"

# TMUX plugin config 
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_FIXTERM=true
ZSH_TMUX_UNICODE=true


# Which plugins would you like to load?
plugins=(git history zsh-autosuggestions tmux term_tab)

# User configuration
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-bd/bd.zsh

alias l='ls -lah'
alias cp='rsync -r -ah --info=progress2'
alias tmux='tmux -2'

ipinfo() {
	http --body ipinfo.io/$1
}

export LANG=en_US.UTF-8
export LANGUAGE=
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

export EDITOR="vim"

REPORTTIME=10

if [ -f $HOME/.dotfiles-first-run ]; then
	echo "You have successfully installed chmod's dotfiles"
	rm $HOME/.dotfiles-first-run
fi;
