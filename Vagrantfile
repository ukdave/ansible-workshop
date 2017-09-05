# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/6"
  config.ssh.insert_key = false

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http = ENV["http_proxy"]
    config.proxy.https = ENV["https_proxy"]
    no_proxy = %w[localhost 127.0.0.1 lb1 192.168.10.10 web1 192.168.10.11 web2 192.168.10.12]
    config.proxy.no_proxy = (ENV["no_proxy"] || "").split(",").concat(no_proxy).uniq.join(",") if config.proxy.http
  end

  config.vm.define "lb1" do |cfg|
    cfg.vm.hostname = "lb1"
    cfg.vm.network "private_network", ip: "192.168.10.10"
  end

  config.vm.define "web1" do |cfg|
    cfg.vm.hostname = "web1"
    cfg.vm.network "private_network", ip: "192.168.10.11"
  end

  config.vm.define "web2" do |cfg|
    cfg.vm.hostname = "web2"
    cfg.vm.network "private_network", ip: "192.168.10.12"
  end
end
