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

  describe 'exclude_formats' do
    it 'is nil by default' do
      RubyProf::Rails::Config.exclude_formats.must_equal RubyProf::Rails::Config::DEFAULT_EXCLUDE_FORMATS
    end

    it 'can be set' do
      RubyProf::Rails::Config.exclude_formats = 'jpg, gif, png'
      RubyProf::Rails::Config.exclude_formats.must_equal 'jpg, gif, png'
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
