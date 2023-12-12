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

skip_msg() {
    echo -e "$1 : \033[32mSKIPPED\033[0m"
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

install_nerd_font() {
    if [[ $(fc-list | grep "FiraCode") ]]
    then
	skip_msg "INSTALL FONT"
    else
        if [ ! -f "$(xdg-user-dir DOWNLOAD)/FiraCode.zip" ]
        then
	    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip -O "$(xdg-user-dir DOWNLOAD)/FiraCode.zip"
	    check_cmd "DOWNLOAD FONTS IN DOWNLOAD FOLDER"
        else
            skip_msg "DOWNLOAD FONTS IN DOWNLOAD FOLDER"
        fi
        if [ ! -d "$(xdg-user-dir DOWNLOAD)/FiraCode" ]
        then
	    unzip "$(xdg-user-dir DOWNLOAD)/FiraCode.zip" -d "$(xdg-user-dir DOWNLOAD)/FiraCode" 
	    check_cmd "UNZIP FONTS IN DOWNLOAD FOLDER"
        else
            skip_msg "UNZIP FONTS IN DOWNLOAD FOLDER"
        fi
	mkdir -p ~/.local/share/fonts
	check_cmd "PREPARE FONTS FOLDER"
	cp $(xdg-user-dir DOWNLOAD)/FiraCode/* ~/.local/share/fonts/
	check_cmd "INSTALL FONTS"
	fc-cache -fv
	check_cmd "FONT RELOAD CACHE"
    fi

    # https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
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
install_nerd_font
sync_doom
