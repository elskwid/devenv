# devenv Vagrantfile
require "yaml"
vagrantfile_path = File.expand_path(File.dirname(__FILE__))
env_definition_path = File.join(vagrantfile_path, "personal", "envs.yml")
env_definitions = YAML.load_file(env_definition_path)

Vagrant.configure("2") do |config|
  env_definitions.each do |env_name, env_def|
    # machine
    config.vm.define env_name do |machine|
      machine.vm.boot_timeout = 120
      machine.vm.box = env_def[:box]
      machine.vm.hostname = env_name
      machine.vm.provider "virtualbox" do |vbox|
        vbox.gui = false
        vbox.name = env_name
        vbox.memory = env_def[:memory]
        vbox.cpus = env_def[:cpus]
        # ensure time sync is on
        vbox.customize [
          "setextradata",
          :id,
          "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled",
          "0"
        ]
        # set sync threshold
        vbox.customize [
          "guestproperty",
          "set",
          :id,
          "/VirtualBox/GuestAdd/VBoxService/-timesync-set-threshold",
          15000
        ]
      end

      # ssh
      config.ssh.forward_agent = true

      # networking
      machine.vm.network :private_network, type: "dhcp"

      # folders
      [
        [".", "/vagrant"],
        ["./personal/shared", "/home/#{env_name}/shared"],
        ["./personal/envs/#{env_name}", "/home/#{env_name}/env"]
      ].each do |(host, guest)|
        unless File.exist?(File.expand_path(File.join(vagrantfile_path, host)))
          next puts "[DEVENV] skip nonexistent '#{host}'"
        end

        machine.vm.synced_folder host, guest, type: "nfs"
      end

      # ports
      Array(env_def[:ports]).each do |port|
        machine.vm.network :forwarded_port, host: port[:host], guest: port[:guest]
      end

      machine.vm.provision :chef_solo do |chef|
        chef.log_level = "info"
        chef.synced_folder_type = "nfs"
        chef.provisioning_path = "/tmp/vagrant-chef"
        chef.cookbooks_path = ["cookbooks", "personal/cookbooks"]
        chef.roles_path = ["personal/roles"]
        chef.json = { machine: { name: env_name }.merge(env_def) }
        chef.run_list = ["role[#{env_name}]"]
      end
    end # define machine
  end # ENV_DEFINITIONS

  # provisioning
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "personal/Berksfile"
end
