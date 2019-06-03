@echo off
set VAGRANT_DOTFILE_PATH=.vagrant-ansible
set VAGRANT_VAGRANTFILE=Vagrantfile.ansible
vagrant %*
set VAGRANT_DOTFILE_PATH=
set VAGRANT_VAGRANTFILE=