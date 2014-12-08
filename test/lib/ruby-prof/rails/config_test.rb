require 'test_helper'

describe RubyProf::Rails::Profiles do

  before do
    RubyProf::Rails::Config.username = nil
    RubyProf::Rails::Config.password = nil
    RubyProf::Rails::Config.session_auth_lambda = lambda do |session|
      session[:is_admin] == true
    end

    ::Rails.application.config.cache_classes = true
    @env = {'rack.session' => {ruby_prof_rails: {enabled: true} }}
  end

  describe 'username' do
    it 'is nil by default' do
      RubyProf::Rails::Config.username.must_be_nil
    end

    it 'can be set' do
      RubyProf::Rails::Config.username = 'test'
      RubyProf::Rails::Config.username.must_equal 'test'
    end
  end

  describe 'password' do
    it 'is nil by default' do
      RubyProf::Rails::Config.password.must_be_nil
    end

    it 'can be set' do
      RubyProf::Rails::Config.password = 'test'
      RubyProf::Rails::Config.password.must_equal 'test'
    end
  end

  describe 'extract_options_from' do
    it 'returns a hash regardless' do
      options = RubyProf::Rails::Config.extract_options_from('rack.session' => {})
      options.must_be_kind_of Hash
    end

    it 'gets options from session variable' do
      options = RubyProf::Rails::Config.extract_options_from @env
      options[:enabled].must_equal true
    end
  end

  describe 'properly_configured?' do
    it 'returns false when no username or password is set' do
      RubyProf::Rails::Config.properly_configured?.must_equal false
    end

    it 'returns false when cache class is false' do
      RubyProf::Rails::Config.username = 'test'
      ::Rails.application.config.cache_classes = false
      RubyProf::Rails::Config.properly_configured?.must_equal false
    end

    it 'returns true when username is set' do
      RubyProf::Rails::Config.username = 'test'
      RubyProf::Rails::Config.properly_configured?.must_equal true
    end

    it 'returns true when password is set' do
      RubyProf::Rails::Config.password = 'test'
      RubyProf::Rails::Config.properly_configured?.must_equal true
    end

  end

  describe 'alerts' do
    it 'returns returns 2 errors with no username/password and cache_classes = false' do
      ::Rails.application.config.cache_classes = false
      RubyProf::Rails::Config.alerts.length.must_equal 2
    end

    it 'returns returns 1 error with cache_classes = false' do
      ::Rails.application.config.cache_classes = false
      RubyProf::Rails::Config.password = 'test'
      RubyProf::Rails::Config.alerts.length.must_equal 1
    end
    it 'returns returns 1 error with no username/password' do
      RubyProf::Rails::Config.alerts.length.must_equal 1
    end
  end

  describe 'session_authenticate' do
    it 'returns true' do
      mock_session = {is_admin: true}
      RubyProf::Rails::Config.session_authenticate?(mock_session).must_equal true
    end

    it 'returns true if session_authenticate is not set' do
      RubyProf::Rails::Config.session_auth_lambda = nil
      RubyProf::Rails::Config.session_authenticate?({}).must_equal true
    end

    it 'returns false' do
      mock_session = {is_admin: false}
      RubyProf::Rails::Config.session_authenticate?(mock_session).must_equal false
    end
  end

  describe 'http_basic_authenticate' do
    it 'returns a hash' do
      RubyProf::Rails::Config.http_basic_authenticate.must_be_kind_of Hash
      RubyProf::Rails::Config.http_basic_authenticate[:name].must_equal nil
    end

    it 'returns a hash with user test' do
      RubyProf::Rails::Config.username = 'test'
      RubyProf::Rails::Config.http_basic_authenticate[:name].must_equal 'test'
    end
  end



end
