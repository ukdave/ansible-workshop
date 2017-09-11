# frozen_string_literal: true

require "serverspec"
require "net/ssh"

Dir["./spec/shared/**/*.rb"].sort.each { |f| require f }

set :backend, :ssh

if ENV["ASK_SUDO_PASSWORD"]
  begin
    require "highline/import"
  rescue LoadError
    raise "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV["SUDO_PASSWORD"]
end

host = ENV["TARGET_HOST"]

ssh_config_files = ["./spec/ssh-config"] + Net::SSH::Config.default_files
options = Net::SSH::Config.for(host, ssh_config_files)

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options
