# devenv Vagrantfile
require "yaml"
vagrantfile_path = File.expand_path(File.dirname(__FILE__))
# top-level env definitions
envs_file = File.join(vagrantfile_path, "personal", "envs.yml")
# individual env definitions
env_files = Dir[File.join(vagrantfile_path, "personal", "envs", "*.yml")]

env_definitions = ([envs_file] + env_files).reduce({}) do |hash, path|
  hash.merge! YAML.load_file(path) if File.exist?(path)
end

Vagrant.configure("2") do |config|
  env_definitions.each do |env_name, env_def|
    # machine
    config.vm.define env_name do |machine|
      machine.vm.boot_timeout = 120
      machine.vm.box = env_def[:box]
      machine.vm.hostname = env_name

      machine.vm.provider "vmware_fusion" do |v|
        v.gui = false
        v.name = env_name
        v.vmx["memsize"] = env_def[:memory]
        v.vmx["numvcpus"] = env_def[:cpus]
      end

      machine.vm.provider "virtualbox" do |v|
        v.gui = false
        v.name = env_name
        v.memory = env_def[:memory]
        v.cpus = env_def[:cpus]
        # ensure time sync is on
        v.customize [
          "setextradata",
          :id,
          "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled",
          "0"
        ]
        # set sync threshold
        v.customize [
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
      host_env_home = "./personal/envs/#{env_name}"
      guest_env_home = "/home/#{env_name}"

      # folders defined in env are relative to home
      env_folders = Array(env_def[:folders]).map do |folder|
        folder[:host] = File.join(host_env_home, folder[:host])
        folder[:guest] = File.join(guest_env_home, folder[:guest])

        folder
      end

      # default folders + fsnotify
      # [host_path, guest_path, notify (true|false)]
      default_folders = [
        # default vagrant folder
        {
          host: ".",
          guest: "/vagrant",
          notify: false
        },
        # shared to all guests
        {
          host: "./personal/shared",
          guest: "#{guest_env_home}/shared",
          notify: false
        },
      ]

      if env_folders.empty?
        # share entire env if no folders are specified
        default_folders << {
          host: host_env_home,
          guest: "#{guest_env_home}/env",
          notify: false
        }
      end

      (default_folders + env_folders).each do |folder|
        unless File.exist?(File.expand_path(File.join(vagrantfile_path, folder[:host])))
          next puts "[DEVENV] skip nonexistent host folder '#{folder[:host]}'"
        end

        machine.vm.synced_folder folder[:host],
                                 folder[:guest],
                                 type: "nfs",
                                 fsnotify: folder[:notify],
                                 exclude: folder.fetch(:exclude, [])
      end

      # ports
      Array(env_def[:ports]).each do |port|
        machine.vm.network :forwarded_port, host: port[:host], guest: port[:guest]
      end

      machine.vm.provision :chef_solo do |chef|
        chef.log_level = "info"
        chef.synced_folder_type = "nfs"
        chef.provisioning_path = "/tmp/vagrant-chef-#{env_name}"
        chef.cookbooks_path = ["cookbooks", "personal/cookbooks"]
        chef.roles_path = ["personal/roles"]
        chef.json = { machine: { name: env_name }.merge(env_def) }
        chef.run_list = ["role[#{env_name}]"]
      end

      # workaround bug in Vagrant for cached folders
      # https://github.com/mitchellh/vagrant/issues/5199
      machine.trigger.before [:reload, :up, :provision], stdout: true do
        info "Cleaning up synced_folders for #{env_name}..."
        %w(virtualbox vmware_fusion).each do |provider|
          system "rm .vagrant/machines/#{env_name}/#{provider}/synced_folders"
        end
      end
    end # define machine
  end # ENV_DEFINITIONS

  # provisioning
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "personal/Berksfile"
end
