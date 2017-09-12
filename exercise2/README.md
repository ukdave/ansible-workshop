# Exercise 2: Playbooks

Write a playbook that will install Apache on both web servers and add some content.

You can run your playbook with this command:

```bash
ansible-playbook site.yml -i hosts
```

You can access both web servers in your browser at <http://192.168.10.11> and <http://192.168.10.12>.


## Step 0: Rebuild vagrant VMs

Before we get going, rebuild the Vagrant VMs by running `vagrant destroy` and then `vagrant up` to ensure they are in a
clean state.


## Step 1: Install and start Apache

The `site.yml` file will be our playbook and needs to contain one play with all the necessary tasks to install Apache
and add some content.

Use the `package` module to install the `httpd` package.

Use the `service` module to ensure `httpd` is started.

Move on to the next step when you can see the "_Apache 2 Test Page_" in your browser.


## Step 2: Add some content

We need to replace the default test page with something else. We can do this by putting an `index.html` file in the
`/var/www/html/` directory.

The `copy` module has a `content` parameter which can set the content of the file directly to a specific value. E.g:

```yaml
copy:
  content: "<h1>Hello from Ansible!</h1>"
  dest: /path/to/some/file
```

If you get the error `Aborting, target uses selinux but python bindings (libselinux-python) aren't installed!`
try adding another task to your playbook to install the `libselinux-python` package before you use the `copy` module.

Move on to the next step when you can see your custom message in the browser.


## Step 3: Include a variable in the message

We can include variables in our message using the syntax `{{ variable_name }}`.

Try including the host name and distribution name in your message.

Playbooks automatically run the `setup` module by default. This module gathers lots of useful variables about remote
hosts that we can use in our playbooks. Remember from exercise 1 that we can use ad-hoc commands to run modules,
e.g. `ansible web1 -i hosts -m setup`.

_Hint_: the `ansible_hostname` and `ansible_distribution` variables might be useful here.

You've finished the exercise when both web servers display a custom message that includes their host name and
distribution name.
