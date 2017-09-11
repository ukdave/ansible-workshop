# frozen_string_literal: true

shared_examples "apache::init" do
  describe package("httpd") do
    it { should be_installed }
  end

  describe service("httpd") do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file("/var/www/html/index.html") do
    its(:content) { should match(/Hello/) }
  end
end
