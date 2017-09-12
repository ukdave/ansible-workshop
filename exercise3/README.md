# Exercise 3: Playbooks and Roles

Take the list of tasks in the site.yml playbook and split them into a `common` role and an `apache` role.


## Step 0: Rebuild vagrant VMs

Before we get going, rebuild the Vagrant VMs by running `vagrant destroy` and then `vagrant up` to ensure they are in a
clean state.


## Step 1: Create a common role

Installing the `libselinux-python` package doesn't really have anything to do with Apache and we will probably want to
install it on all our servers. Let's create a common role to perform tasks that apply to all our servers.

Create the file `roles/common/tasks/main.yml` and copy the task that installs the `libselinux-python` package from
`site.yml`. Remember, YAML files start with `---` and you don't need to include the `tasks:` heading in the role tasks
file.

If you get stuck have a look at `../exercise3-solution/roles/common/tasks/main.yml`.


## Step 2: Create an apache role and use templates

Create the file `roles/apache/tasks/main.yml` and copy the remaining tasks from from `site.yml`.

The contents of `index.html` is currently hard coded as a string in the task definition. Lets pull it out into a
template. Create the file `roles/apache/templates/index.html.j2` with the following content:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <h1>Hello from {{ ansible_hostname }} running on {{ ansible_distribution }} {{ ansible_distribution_version }}!</h1>
  </body>
</html>
```

Now change the `copy` task to use the `template` module instead:

```yaml
template: src=index.html.j2 dest=/var/www/html/index.html
```


## Step 3: Update the playbook to use roles

Now we've moved all the tasks out into the two roles, we need to update the `site.yml` playbook to call the roles.

Replace the `tasks` section with a `roles` section that lists the two roles we've just created.

If you get stuck have a look at `../exercise3-solution/site.yml`.

Run the playbook (`ansible-playbook site.yml -i hosts`) and check both web servers (<http://192.168.10.11> and
<http://192.168.10.12>) display a custom message that includes their host name and distribution.
