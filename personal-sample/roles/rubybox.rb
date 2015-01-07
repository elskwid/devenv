name "rubybox"
description "Sample devenv for a ruby box with node"

run_list(
  "recipe[devenv]",
  "recipe[devenv::env-user]",
  "recipe[devenv-personal]",
  "recipe[devenv-personal::node]",
  "recipe[devenv-personal::ruby]"
)

default_attributes(
  "brightbox-ruby" => {
    gem_packages: %w[rake bundler],
    ruby_version: "2.1"
  },
  nodejs: {
    version: "2.1.6",
    npm_packages: [
      { name: "npm" }
    ]
  }
)
