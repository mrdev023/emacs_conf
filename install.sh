#!/bin/bash

#################
### FONCTIONS ###
#################

# FROM https://github.com/aaaaadrien/fedora-config/blob/main/config-fedora.sh
check_cmd()
{
    if [[ $? -eq 0 ]]
    then
        echo -e "$1 : \033[32mOK\033[0m"
    else
        echo -e "$1 : \033[31mERREUR\033[0m"
    fi
}

prepare_doom() {
    if [ ! -d ~/.config/emacs ]
    then
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
        check_cmd "INSTALL DOOM"
    else
	~/.config/emacs/bin/doom upgrade
	check_cmd "UPDATE DOOM"
    fi
}

prepare_custom_conf() {
    if [ ! -d ~/.config/doom ]
    then
        git clone https://gitea.mrdev023.fr/florian.richer/emacs_conf ~/.config/doom
        check_cmd "INSTALL CUSTOM CONF"
    else
        git -C ~/.config/doom pull origin main
	check_cmd "UPDATE CUSTOM CONF"
    fi
}

sync_doom() {
    ~/.config/emacs/bin/doom sync
    check_cmd "FINISH DOOM INSTALL"
}
#####################
### FIN FONCTIONS ###
#####################

#################
### PROGRAMME ###
#################

prepare_doom
prepare_custom_conf
sync_doom
