# frozen_string_literal: true

require "spec_helper"

describe "192.168.10.11" do
  include_examples "ntp::init"
  include_examples "apache::init"
end
