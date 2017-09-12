# Exercise 4: More Playbooks and Roles

Update the `common` role and get it to install and configure NTP, and then create a new role to install HAProxy on the
load balancer server.


## Step 0: Rebuild vagrant VMs

Before we get going, rebuild the Vagrant VMs by running `vagrant destroy` and then `vagrant up` to ensure they are in a
clean state.


## Step 1: Add NTP to common role

In a production environment it's usually a good idea to ensure that the time across all the servers is synchronised.
This can be accomplished by installing and configuring an NTP daemon on each server. Lets add some tasks to the
`common` role to do this.


### Step 1a: Create tasks

In order to avoid having lots of tasks that do different things in a single tasks file, lets move our existing SELinux
task into a new file called `selinux.yml` and then create a new file called `ntp.yml` for our NTP tasks.

We should now have the following files inside `roles/common/tasks/` directory:

*   `main.yml`
*   `selinux.yml`
*   `ntp.yml`

Update the `main.yml` file so that includes the other two files:

```yaml
---

- include: selinux.yml
- include: ntp.yml
```

In the `ntp.yml` file add tasks to install and configure the `ntp` package:

```yaml
- name: install ntp
  package: name=ntp state=present

- name: configure ntp file
  template: src=ntp.conf.j2 dest=/etc/ntp.conf
  notify: restart ntp

- name: start ntp
  service: name=ntpd state=started enabled=yes
```


### Step 1b: Configuration template

We're going to use a template to configure the NTP daemon and use a variable to specify the NTP server that we want to
synchronise to.

Create the file `roles/common/templates/ntpd.conf.j2` with the following content:

```
driftfile /var/lib/ntp/drift

restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict -6 ::1

server {{ ntp_server }} iburst

includefile /etc/ntp/crypto/pw

keys /etc/ntp/keys
```

The template contains a variable called `ntp_server` which will be replaced with the actual value when the template is
rendered. As we want all our servers to synchronise to the same time server lets use a group_vars file.

Create the file `group_vars/all` with the following content:

```yaml
---

ntp_server: 0.pool.ntp.org
```

### Step 1c: Handler

Finally, we want to make sure the NTP daemon is restarted if the config file is changed. Our template task already
includes a line to notify a handler called `restart ntp`.

Create the file `roles/handlers/main.yml` with the following content:

```yaml
---

- name: restart ntp
  service: name=ntpd state=restarted
```


### Step 1d: Run the playbook and test NTP

Run the playbook to install and configure the NTP daemon:

```bash
ansible-playbook site.yml -i hosts
```

We can check whether the NTP daemon was installed and configured correctly by logging into each VM:

```
$ vagrant ssh web1
Last login: Wed Sep  6 14:10:33 2017 from 10.0.2.2
[vagrant@web1 ~]$ ntpdc -p
     remote           local      st poll reach  delay   offset    disp
=======================================================================
*195.219.205.9   10.0.2.15        1   64    1 0.01233 -0.001659 0.66162
```


## Step 2: Add a new haproxy role

Now we want to install and configure HAProxy on our load balancer to distribute incoming requests to our two web
servers.

Create a new role called `haproxy` and add the following tasks:

```yaml
---

- name: install haproxy
  package: name=haproxy state=present

- name: configure haproxy
  template: src=haproxy.cfg.j2 dest=/etc/haproxy/haproxy.cfg
  notify: restart haproxy

- name: start haproxy
  service: name=haproxy state=started enabled=yes
```

As before, we will use a template to configure HAProxy. Create the file `roles/haproxy/templates/haproxy.cfg.j2` with
the following content:

```
global
    chroot  /var/lib/haproxy
    pidfile /var/run/haproxy.pid
    maxconn 4000
    user    haproxy
    group   haproxy
    daemon

defaults
    mode    http
    timeout connect 10s
    timeout client  30s
    timeout server  30s
    timeout check   10s

frontend http-in
    bind *:80
    default_backend servers

backend servers
    balance roundrobin
    stats   enable
    stats   uri /haproxy
    stats   refresh 5s
{% for host in groups["webservers"] %}
    server  {{ host }} {{ hostvars[host].ansible_eth1.ipv4.address }}:80 check inter 2000 rise 2 fall 5
{% endfor %}
```

Notice that the template uses a for-loop to automatically add `server` lines to the HAProxy configuration for each
server in the `webservers` group. We also use the `ansible_eth1.ipv4.address` variable (discovered by Ansible's `setup`
module) to get the IP address of each server.

Finally, add a handler called `restart haproxy` to restart the `haproxy` service.


## Step 3: Update the playbook

Update the `site.yml` playbook and add a new play that applies the `common` and `haproxy` roles to the `loadbalancers`
group.

Run the playbook and then browse to <http://192.168.10.10>. If HAProxy was installed and configured correctly then
each time you refresh the page you will see the message from each of the web servers.
