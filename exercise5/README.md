# Exercise 5: Testing with Serverspec

__Objective__: Use [Serverspec](http://serverspec.org/) to test the VMs are configured correctly.


## Step 0: Rebuild vagrant VMs

Before we get going, rebuild the Vagrant VMs by running `vagrant destroy` and then `vagrant up` to ensure they are in a
clean state.


## Step 1: Install Serverspec

Serverspec is a Ruby tool for testing your servers. The following files and directories have been added to the project:

*   `.rspec` - configuration file for rspec
*   `Gemfile` - lists the dependencies (gems) for Ruby programs
*   `Gemfile.lock` - records the exact versions of the dependencies (gems)
*   `Rakefile` - like Makefiles, but for Ruby
*   `spec/` - directory containing all our tests

Assuming you have a working Ruby installation, run `bundle install` to install the gems listed in the Gemfile.

Runnning `rake` will run all the tests in the spec directory:

```
$ rake
No examples found.

Finished in 0.00029 seconds (files took 1.62 seconds to load)
0 examples, 0 failures

No examples found.

Finished in 0.00025 seconds (files took 1.23 seconds to load)
0 examples, 0 failures

No examples found.

Finished in 0.00029 seconds (files took 1.18 seconds to load)
0 examples, 0 failures
```


## Step 2: Write some specs

Currently we don't have any tests, lets change that...

Serverspec expects there to be one spec file for each server we want to test. These files are named `HOSTNAME_spec.rb`
and live under the `spec/` directory. Three such files have already been created; one for each of the Vagrant VMs we've
been building:

*   `spec/192.168.10.10_spec.rb` - tests for load balancer
*   `spec/192.168.10.11_spec.rb` - tests for web server 1
*   `spec/192.168.10.12_spec.rb` - tests for web server 2

As some of the servers have common functionality, there are also some shared test files:

*   `spec/shared/apache/init.rb`
*   `spec/shared/ntp/init.rb`

Notice that all three host specs already include the shared `ntp` spec, and that the specs for 192.168.10.11 and
192.168.10.12 also include the shared `apache` spec.

Lets start by adding some tests for HAProxy to check that the package is installed, the process is enabled and running,
and that port 80 is listening. Edit `192.168.10.10_spec.rb` and add the following tests:

```ruby
describe package("haproxy") do
  it { should be_installed }
end

describe service("haproxy") do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
```

As we re-built the VMs at the beginning of this exercise, running `rake` should show that these tests fail:

```
192.168.10.10
  Package "haproxy"
    should be installed (FAILED - 1)
  Service "haproxy"
    should be enabled (FAILED - 2)
    should be running (FAILED - 3)
  Port "80"
    should be listening (FAILED - 4)

...
```

Run the Ansible playbook to provision the VMs (`ansible-playbook site.yml -i hosts`) and then run `rake` again:

```
192.168.10.10
  Package "haproxy"
    should be installed
  Service "haproxy"
    should be enabled
    should be running
  Port "80"
    should be listening

Finished in 0.9904 seconds (files took 1.16 seconds to load)
4 examples, 0 failures

No examples found.

Finished in 0.00027 seconds (files took 1.54 seconds to load)
0 examples, 0 failures

No examples found.

Finished in 0.00026 seconds (files took 1.25 seconds to load)
0 examples, 0 failures
```


## Step 3: Add some specs for NTP

Now add some specs to test that NTP daemon is installed and configured correctly.

Edit `spec/shared/ntp.init.rb` and add some specs to check that:

*   the `ntp` package is installed
*   the `ntpd` service is enabled and running

Finally add a spec to check the NTP daemon is configured to use our preferred NTP server:

```ruby
describe file("/etc/ntp.conf") do
  its(:content) { should match(/server 0\.pool\.ntp\.org iburst/) }
end
```

Run `rake` and check that all the tests pass.


## Step 4: Add some specs for Apache

Finally, add some specs to test that Apache is installed and configured correctly.

Edit `spec/shared/ntp.init.rb` and add some specs to check that:

*   the `httpd` package is installed
*   the `httpd` service is enabled and running
*   port 80 is listening
*   the `/var/www/html/index.html` file contains the string "Hello"

Run `rake` and check that all the tests pass.
