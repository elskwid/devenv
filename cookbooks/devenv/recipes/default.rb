include_recipe "apt"
include_recipe "build-essential"
include_recipe "timezone"

# Make sure vagrant user is in sudo group
group "sudo" do
  action :modify
  members "vagrant"
  append true
end

package "git-core"
package "ntp"
