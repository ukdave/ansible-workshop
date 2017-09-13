# Exercise 1: Ad-Hoc Commands

Start the Vagrant VMs using the `vagrant up` command. This may take a few minutes the very first time as Vagrant
downloads the CentOS 6 box.

This will create three CentOS 6 virtual machines:

*   `lb1` on `192.168.10.10`
*   `web1` on `192.168.10.11`
*   `web2` on `192.168.10.12`

Have a look in the `hosts` file in this repository. This is an Ansible inventory file that defines these three hosts
and configures them in two groups. This allows us to target individual hosts, or groups of hosts. The inventory file
also specifies a couple of variables to configure the username and SSH key that will be used to connect to the VMs.

If you need to rebuild the VMs at any point use the `vagrant destroy` command and then run `vagrant up` again.


## Ping-Pong

Check Ansible can connect to all the virtual machines:

```
$ ansible all -i hosts -m ping
lb1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
web1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
web2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```


## Running commands

Run the `uptime` command on all the hosts in the `webservers` group:

```
$ ansible webservers -i hosts -m command -a "uptime"
web1 | SUCCESS | rc=0 >>
 08:56:22 up 58 min,  1 user,  load average: 0.00, 0.00, 0.00
```


## Gathering facts

Run the `setup module` command on `web1`:

```
$ ansible web1 -i hosts -m setup
web1 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "10.0.2.15",
            "192.168.10.10"
        ],
...
        "ansible_distribution": "CentOS",
        "ansible_distribution_major_version": "6",
        "ansible_distribution_release": "Final",
        "ansible_distribution_version": "6.9",
...
    },
    "changed": false
}
```


## Installing packages

We can use Ansible's `package` module to install packages. Root privileges are typically required to install software
packages so we need to use the `-b` option to use privilege escalation. Try the command with and without the `-b`
option to see what happens.

```bash
ansible webservers -i hosts -m package -a "name=httpd state=present" -b
```

Ansible is idempotent meaning that performing the same action multiple times has the same effect as running it just
once. Try running the same command again to to install Apache, but notice that the output says nothing was changed.

Now try uninstalling Apache by changing the state to `absent`:

```bash
ansible webservers -i hosts -m package -a "name=httpd state=absent" -b
```

Run this command again and notice that the second time nothing is changed.
