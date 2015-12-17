name             "devenv"
maintainer       "Don Morrison"
maintainer_email "don@elskwid.net"
license          "MIT License"
description      "Cookbook for dev envs with Vagrant, Chef, and (maybe) Docker"
version          "0.1.0"

# machine
depends "apt", "~> 2.6"
depends "build-essential", "~> 2.0"
depends "sudo", "> 1.7.2"
depends "timezone"
depends "yum", "~> 3.0"
