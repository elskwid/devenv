include_recipe "brightbox-ruby"

package "ruby#{node["brightbox-ruby"]["ruby_version"]}-dev"

cookbook_file "gemrc" do
  path "/etc/gemrc"
end

# Utility script to reset our gem install to defaults only
remote_file "/usr/local/bin/gem-reset" do
  source "https://gist.githubusercontent.com/elskwid/969970102ce8a9469f99/raw/7daa611e707f1884eb701551464bfd1dc9e7a953/gem-reset"
  mode "0755"
end
