#!/bin/bash

# Location for the dotfiles
DOTFILES_DIR="dotfiles"

# Some dotfiles require custom configuration.
# Location for templates
TEMPLATES_DIR="templates"

# Let's give output a bit of colour
function coloured() {
    printf "\033[00;$1m==> $2\033[0m\n"
}

function error() {
    coloured "31", "$1"
}

function success() {
    coloured "32", "$1"
}

function warning() {
    coloured "33", "$1"
}

function info() {
    coloured "34", "$1"
}

gitconfig_fields=(AUTHORNAME AUTHOREMAIL)

customize_template() {
    dotfile=${DOTFILES_DIR}/$1
    if ! [ -f ${dotfile} ]
    then
        info "Configuring dotfile ${dotfile}."
        cp ${TEMPLATES_DIR}/$1 dotfile.tmp
        eval fields=( '"${'$1'_fields[@]}"' )
        for field in "${fields[@]}"
        do
            echo "Please select a value for ${field}:"
            read -e value
            sed -i '' "s/${field}/${value}/g" dotfile.tmp
        done
        info "Dotfile ${dotfile} generated."
        mv dotfile.tmp ${dotfile}
    else
        warning "File ${dotfile} already exists. Ignoring."
    fi
}

customize() {
    for template in ${TEMPLATES_DIR}/*
    do
        info "Found template ${template}"
        customize_template `basename ${template}`
    done
}

install() {

    for dotfile in `pwd`/${DOTFILES_DIR}/*
    do
        target="$HOME/.`basename ${dotfile}`"
        if [ -f $target ] || [ -d $target ]
        then
            warning "File ${target} already exists. Ignoring."
        else
            ln -s $dotfile $target
            success "File ${dotfile} installed."
        fi
    done
}

info "Customizing templates."
customize

info "Installing templates"
install

success "Completed."

exit 0
