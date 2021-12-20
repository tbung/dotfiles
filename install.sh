#!/bin/bash

ln -vsf $(pwd) ${HOME}/.dotfiles

ln -vsf $(pwd)/.profile ${HOME}/.profile

for file in .config/*
do
    ln -vsf $(pwd)/$file ${HOME}/$file
done

for file in .local/*
do
    ln -vsf $(pwd)/$file ${HOME}/$file
done
