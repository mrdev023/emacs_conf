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
        git clone git@gitea.mrdev023.fr:florian.richer/emacs_conf.git ~/.config/doom
        check_cmd "INSTALL CUSTOM CONF"
    else
        git -C ~/.config/doom pull origin main
        check_cmd "UPDATE CUSTOM CONF"
    fi
}

prepare_fira_code_nerd_font() {
    if [ -d ~/.local/share/fonts/fira_code ]
    then
        rm -rf ~/.local/share/fonts/fira_code
        check_cmd "REMOVE OLD FIRA CODE INSTALLATION"
    fi

    curl -L -o ~/fira_code.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.tar.xz
    check_cmd "DOWNLOAD FIRA CODE NERD FONT"

    mkdir -p ~/.local/share/fonts/fira_code
    check_cmd "PREPARE FIRA CODE NERD FONT INSTALLATION"

    tar -xvf ~/fira_code.tar.xz -C ~/.local/share/fonts/fira_code
    check_cmd "INSTALL FIRA CODE NERD FONT"

    fc-cache -f -v
    check_cmd "UPDATE FONT CACHE"

    rm -rf ~/fira_code.tar.xz
    check_cmd "REMOVE USELESS FIRA CODE NERD FONT FILES"
}

install_required_packages() {
    sudo dnf install emacs ripgrep fish fd-find git gdb -y
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

install_required_packages
prepare_fira_code_nerd_font
prepare_doom
prepare_custom_conf
sync_doom
