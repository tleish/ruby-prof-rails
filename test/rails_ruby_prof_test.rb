require 'test_helper'
require 'ruby_prof_rails'
require 'rack/test'

class RubyProfRailsTest < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, RubyProfRails
  end


end