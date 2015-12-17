case node["platform_family"]
when "debian"
  include_recipe "apt"
  include_recipe "build-essential"
when "rhel"
  include_recipe "yum"
  package "sudo.x86_64"
end

include_recipe "timezone"

sudo "vagrant" do
  user "vagrant"
  nopasswd true
end

package "git-core"
package "ntp"
