require 'test_helper'
require './lib/ruby-prof/rails/config_validation'

describe RubyProf::Rails::ConfigValidation do

  before do
    @config = RubyProf::Rails::Config
    @app_config = OpenStruct.new
    @env = mock_env
    reset
  end

  describe 'properly_configured?' do
    it 'returns false when no username or password is set' do
      config_validation.properly_configured?.must_equal false
    end

    it 'returns false when cache class is false' do
      @config.username = 'test'
      @app_config.cache_classes = false
      config_validation.properly_configured?.must_equal false
    end

    it 'returns true when username is set' do
      @config.username = 'test'
      config_validation.properly_configured?.must_equal true
    end

    it 'returns true when password is set' do
      @config.password = 'test'
      config_validation.properly_configured?.must_equal true
    end

  end

  describe 'alerts' do
    it 'returns returns 2 errors with no username/password and cache_classes = false' do
      @app_config.cache_classes = false
      config_validation.alerts.length.must_equal 2
    end

    it 'returns returns 1 error with cache_classes = false' do
      @app_config.cache_classes = false
      @config.password = 'test'
      config_validation.alerts.length.must_equal 1
    end

    it 'returns returns 1 error with no username/password' do
      config_validation.alerts.length.must_equal 1
    end
  end

  describe 'session_auth_lambda?' do
    it 'returns true' do
      mock_session = {is_admin: true}
      config_validation.session_auth_lambda?(mock_session).must_equal true
    end

    it 'returns true if session_authenticate is not set' do
      @config.session_auth_lambda = nil
      config_validation.session_auth_lambda?({}).must_equal true
    end

    it 'returns false' do
      mock_session = {is_admin: false}
      config_validation.session_auth_lambda?(mock_session).must_equal false
    end
  end

  private

  def config_validation
    RubyProf::Rails::ConfigValidation.new(config: @config, app_config: @app_config)
  end

  def mock_env
    {'rack.session' => {ruby_prof_rails: {enabled: true} }}
  end

  def reset
    @app_config.cache_classes = true
    @config.username = nil
    @config.password = nil
    @config.session_auth_lambda = lambda do |session|
      session[:is_admin] == true
    end
  end

end
