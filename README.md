# Ansible Workshop

Slides: <https://speakerdeck.com/ukdave/ansible-workshop>


## Requirements

These exercises make use of Vagrant to create a number of virtual machines which we will configure using Ansible.

1.  Install Ansible (using Homebrew on Mac OS X):  
    `brew install ansible`

2.  Install Vagrant:  
    <https://www.vagrantup.com/downloads.html>

3.  Install Proxy Configuration Plugin for Vagrant (optional):  
    `vagrant plugin install vagrant-proxyconf`

4.  Install Ruby (only required for exercise5 - optional)

These exercises have been tested on macOS Sierra with Vagrant 1.9.8, Ansible 2.3.2.0, and Ruby 2.4.1.


## Exercices

*   [Exercise 1: Ad-hoc commands](exercise1/README.md)
*   [Exercise 2: Playbooks](exercise2/README.md)
*   [Exercise 3: Playbook and Roles](exercise3/README.md)
*   [Exercise 4: More Playbooks and Roles](exercise4/README.md)
*   [Exercise 5: Testing with Serverspec](exercise5/README.md)
