#!/usr/bin/env bash

SRC=$(pwd)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d-%H:%M:%S)"

dependencies=(
	git
	zsh
	tmux
)

##############
#   COLORS   #
##############
COLOR_DEFAULT="\e[0m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_BLUE="\e[34m"
COLOR_MAGENTA="\e[35m"
COLOR_CYAN="\e[36m"
#############
#  /COLORS  #
#############


check_dependencies() {
	echo -e "${COLOR_GREEN}Checking dependencies${COLOR_DEFAULT}"
	result=0

	for i in ${dependencies[*]}; do
		echo -ne "  $i"
		if [ -x "$(command -v $i)" ]; then
			echo -e "${COLOR_GREEN} => OK${COLOR_DEFAULT}"
		else
			echo -e "${COLOR_RED} => FAIL${COLOR_DEFAULT}"
			result=1
		fi
	done

	return $result
}


backup() {
	NAME=$(basename $1)

	echo -e "${COLOR_YELLOW}Found ${COLOR_CYAN}$1${COLOR_YELLOW}. ${COLOR_GREEN}Backing up to ${COLOR_CYAN}$BACKUP_DIR/$NAME${COLOR_DEFAULT}"

	if [ ! -d $BACKUP_DIR ]; then
		mkdir $BACKUP_DIR
	fi;

	mv $1 $BACKUP_DIR/$NAME
}


link() {
	echo -e "${COLOR_GREEN}Linking ${COLOR_CYAN}$2 ${COLOR_GREEN}to ${COLOR_CYAN}$SRC/$1${COLOR_DEFAULT}"
	if [ -h $2 ] || [ -f $2 ]; then
		backup $2
	fi

	ln -s $SRC/$1 $2
}


zsh_install() {
	echo -e "${COLOR_GREEN}Installing oh-my-zsh${COLOR_DEFAULT}"

	if [ -d $HOME/.oh-my-zsh ]; then
		backup $HOME/.oh-my-zsh
	fi
	
	git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

	if [ $? -eq 0 ] && [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
		echo -e "${COLOR_GREEN}=> OK${COLOR_DEFAULT}"
		zsh_plugins_install
		link zsh/.zshrc $HOME/.zshrc
	else
		echo -e "${COLOR_RED}=> FAILED${COLOR_DEFAULT}"
		exit
	fi;
}


zsh_plugins_install() {
	echo -e "${COLOR_GREEN}Installing zsh plugins${COLOR_DEFAULT}"
	echo -e "${COLOR_GREEN}--zsh-autosuggestions${COLOR_DEFAULT}"

	git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	if [ $? -eq 0 ] && [ -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
		echo -e "${COLOR_GREEN}=> OK${COLOR_DEFAULT}"
	else
		echo -e "${COLOR_RED}=> FAIL${COLOR_DEFAULT}"
		exit
	fi;
}


tmux_install() {
	echo -e "${COLOR_GREEN}Installing Tmux Plugin Manager${COLOR_DEFAULT}"

	if [ -d $HOME/.tmux ]; then
		backup $HOME/.tmux
	fi

	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

	if [ $? -eq 0 ] && [ -f $HOME/.tmux/plugins/tpm/tpm ]; then
		echo -e "${COLOR_GREEN}=> OK${COLOR_DEFAULT}"
		link tmux/.tmux.conf $HOME/.tmux.conf
		tmux source $HOME/.tmux.conf 2> /dev/null
		tmux_plugins_install
	else
		echo -e "${COLOR_RED}=> FAILED${COLOR_DEFAULT}"
		exit
	fi;
}


tmux_plugins_install() {
	echo -e "${COLOR_GREEN}Installing tmux plugins${COLOR_DEFAULT}"

	~/.tmux/plugins/tpm/bin/install_plugins

	if [ $? -eq 0 ]; then
		echo -e "${COLOR_GREEN}=> OK${COLOR_DEFAULT}"
		tmux source $HOME/.tmux.conf 2> /dev/null
	else
		echo -e "${COLOR_RED}=> FAILED${COLOR_DEFAULT}"
		exit
	fi;
}


main() {
	echo
	echo -e "${COLOR_GREEN}Installing chmod's dotfiles${COLOR_DEFAULT}"
	echo
	
	if check_dependencies; then
		zsh_install
		tmux_install

		echo -e "${COLOR_GREEN}Installation completed${COLOR_DEFAULT}"
		touch $HOME/.dotfiles-first-run
		env zsh -l
	else
		exit
	fi
}

main
