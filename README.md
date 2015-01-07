# devenv

Conventions for Vagrant + Chef development environments.

`devenv` is mostly a single Vagrantfile that expects to find configuration
files in specific locations.

## Goal (WIP)

The goal is to have all development environments consolidated in such a way
that it's easy to view status of existing environments and straightforward to
create/update them.

A simple `vagrant status` is enough to tell us what we need.

### Foundation

`devenv` is built on Vagrant and Chef (Chef DK). With the new installs of each
this makes it simpler to get started. It leverages Vagrant "multi-machine"
environments to unify the interface to the VMs. And yes, each env is a
separate VM. I'd like to work Docker into this plan at some point as well --
ideas?

**Note: All VMs are built with the Virtualbox provider, although it should be
easy enough to make this configurable per-env.**

## Get started

* Install Vagrant, Chef, and Virtualbox (see note above)
* Clone the repo
* Copy `personal-sample` to `personal`
* Run `vagrant status` from anywhere under the top directory
* Add / modify configuration as needed (~magic~)

## Keep it personal

I've chosen to adopt the same convention used in the Emacs Prelude project where
personal configuration details are kept under the `personal` directory. In this
case, the entire directory is ignored so you can make changes and keep in sync
with the main repo. In fact, it should be easy to clone a personal directory
and keep both `devenv` and `devenv/personal` in version control.

The Vagrantfile sets up the chef-solo provisioner to look at the top-level
devenv cookbook, where some basic recipes are housed, and also to find
cookbooks in your personal directory. Berkshelf is also configured to
find it's settings in `personal\Berksfile`.

### The rubybox sample

In the `personal-sample` directory is a working configuration for a single
devenv named **rubybox**. It illustrates the assumptions made by `devenv`
when running.

I'm not going to go into too much detail since this entire operation is still
very much a work in progress. But here are the basics:

#### What devenv needs

To run, `devenv` requires a couple of things:

* `personal` directory
* `personal\envs.yml` file that lists out our environments

#### What a specific devenv needs

For example, our **rubybox** environment needs:

* `personal\envs.yml` entry that sets up the basics for the env
* `personal\roles\rubyboxy.rb` chef role to be used when building the env
* `personal\cookbooks\devenv-personal` chef cookbook that can be used during build
* `personal\envs\rubybox` (Optional) dirs and folders to share with the env
* `personal\shared` (Optional) dirs and folders to share with all envs

Take a look at the sample **rubybox** env for details.

Enjoy.

## License

MIT (See LICENSE.txt)
