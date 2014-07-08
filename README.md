# PUG Presentation: Nick Huanca
Presentation for Puppet User Group #Denver on July 8th 2014

# Presentation Outline
- What we're here to talk about
  - Basic Vagrant / Puppet module development workflow (or testing)
- What is vagrant
  - Setting it up
  - Getting base images
- Setting up your manifests and modules dir.
  - Get it working. Yey a webpage
- Now let's add in Hiera
  - Setting up Hiera config
  - Set up Hiera data dir
  - Setup auto lookup values
- Recap value
  - can test before commits
  - can try different things without really screwing up a machine
- Next steps
  - custom facts
  - adding puppet master

# Follow Along Commands
## Assumptions
- You've installed Vagrant at least version 1.6.3
- These commands were tested using VirtualBox
- We're using Puppet 3.4.x

# Usage (How to use this repo)
## First things first
Clone the master repository
```bash
git clone https://github.com/endzyme/pug_preso.git
```

## Basic Vagrant Init
This is a branch that has the basic Vagrant init. At this point your vagrant up
should work no problems. A good place to start if you're not familiar with
Vagrant. It will download the "base box" and start your VM.

**NOTE: You'll want to reload your vagrant instance every time you checkout a new
branch. The best way to assure consistency is `vagrant destroy -f` before you
`git checkout <new_branch>`.**

```bash
git checkout 1_basic_vagrant_init

# This will start your Vagrant Instance
vagrant up

# This will reboot / halt your instance
vagrant reload
vagrant halt

# This will destroy it (so you can try again)
vagrant destroy

# This will try to run provisioning on it again in place
vagrant provision

# This will reboot and apply provisioning
vagrant reload --provision
```

## Basic Puppet Configuration (puppet standalone)
If you're not using fancy sauce like puppetdb or exported resources then you
should be able to get along without needing a full puppet server setup to test
your modules. Here are some basic setup instructions to get some puppet code
running against your new vagrant machine.

Docs: http://docs.vagrantup.com/v2/provisioning/puppet_apply.html

```bash
git checkout 2_basic_puppet_testing
```

Steps I used to install modules etc
```bash
puppet module install puppetlabs/apache --modulepath ./modules
puppet module generate pugdenver-install_my_website; mv ./pugdenver-install_my_website modules/install_my_website
# I manually added the roles and profiles setup
# I also added a site.pp node classification for hosts named /^vagrant-pug-preso.*$/
```

## Local Hiera Example
With 3.x including hiera as a requirement, we can now run hiera
auto_lookup_params without the need of a full puppetmaster. This helps test
hiera data without having to push to another server or muddy up your commit log.

```bash
git checkout 3_local_hiera_puppet
```

Steps to setup (all included in repo)
- Setup a hiera.yaml configuration
- Setup data you'd like to use via backend
- Add the Vagrant setup for hiera and add a synced folder to lookup data

# What's next?
## Custom Facts in Vagrant
With custom facts you can make sure your manifests will act according to plan
without having to jump through hoops. If you use custom facts anywhere this will
be very useful.
Example of adding custom facts:

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# ...
  config.vm.provision "puppet" do |puppet|
    puppet.facter = {
      "role" => "some_custom_role",
      "openstack" => "true",
    }
  end
```

## Adding Puppet Agent/Master Setup
Documentation on that can be found here: http://docs.vagrantup.com/v2/provisioning/puppet_agent.html
