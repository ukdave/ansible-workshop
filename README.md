# Ansible Workshop

Slides: <https://speakerdeck.com/ukdave/ansible-workshop>


## Requirements

These exercises make use of Vagrant to create a number of virtual machines which we will configure using Ansible.

1.  Install Ansible (using Homebrew on Mac OS X):
    `brew install ansible`

2.  Install VirtualBox:
    <https://www.virtualbox.org/wiki/Downloads>

3.  Install Vagrant:
    <https://www.vagrantup.com/downloads.html>

4.  Install Proxy Configuration Plugin for Vagrant (optional):
    `vagrant plugin install vagrant-proxyconf`

5.  Install Ruby (only required for exercise5 - optional)

These exercises have been tested on macOS Mojave with Vagrant 2.2.4, Ansible 2.8.0, and Ruby 2.6.3.


## Windows Users

Ansible is not available for Windows. The easiest way to use it is by installing it in a Linux VM.

Make sure you have VirtualBox and Vagrant installed and then use the provided `ansible-vm.bat` script to automaticically 
build a CentOS 7 VM and install Ansible:

    ansible-vm.bat up
    ansible-vm.bat ssh
    cd exercices

If prompted to install the `vagrant-vbguest` plugin, please say yes. This will install VirtualBox Guest Additions
inside the Linux VM and enable the exercises folder to be properly synchronised between Windows and the VM.


## Exercices

*   [Exercise 1: Ad-hoc commands](exercise1/README.md)
*   [Exercise 2: Playbooks](exercise2/README.md)
*   [Exercise 3: Playbook and Roles](exercise3/README.md)
*   [Exercise 4: More Playbooks and Roles](exercise4/README.md)
*   [Exercise 5: Testing with Serverspec](exercise5/README.md)
