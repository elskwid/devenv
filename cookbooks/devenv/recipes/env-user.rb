machine_name = node["machine"]["name"]

user_account machine_name do
  comment machine_name
  system_user true
  create_group true
  ssh_keygen false
end

sudo machine_name do
  user machine_name
  nopasswd true
end

# TODO: spend some quality time with ssh and decide how we want to do things
execute "copy-vagrant-ssh" do
  command "cd ~#{machine_name} ; cp -r ~vagrant/.ssh . && chmod 700 .ssh && chown -R #{machine_name} .ssh"
end
