require 'test_helper'
require 'rack/ruby_prof_rails'
require_relative 'mocks/fake_app'

describe Rack::RubyProfRails do
  include Rack::Test::Methods

  attr_accessor :app

  after do
    @app = nil
  end

  describe 'Basic Request Is Not Profiled' do
    it 'returns a string' do
      self.app = Rack::RubyProfRails.new(FakeApp.new)
      RubyProf.expects(:start).never
      RubyProf.expects(:stop).never
      get '/'
      assert last_response.ok?

      get '/?profile_request=false'
      assert last_response.ok?
    end
  end
end
