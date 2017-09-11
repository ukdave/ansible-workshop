# frozen_string_literal: true

shared_examples "ntp::init" do
  describe package("ntp") do
    it { should be_installed }
  end

  describe service("ntpd") do
    it { should be_enabled }
    it { should be_running }
  end

  describe file("/etc/ntp.conf") do
    its(:content) { should match(/server 0\.pool\.ntp\.org iburst/) }
  end
end
