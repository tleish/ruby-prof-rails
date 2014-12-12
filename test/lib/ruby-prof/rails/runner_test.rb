require 'test_helper'
require './test/mocks/fake_app'
require_relative 'cleanup_profiles_module'
require './lib/ruby-prof/rails/runner'
require 'mocha'


describe RubyProf::Rails::Profiles do

  include RubyProf::Rails::CleanupProfilesModule

  before do
    @runner = RubyProf::Rails::Runner.new( env: mock_env, app: mock_app )
  end

  after do
    cleanup_profiles
  end

  describe 'enabled?' do
    it 'it checks if the runner is enabled' do
      @runner.enabled?.must_equal true
    end

    it 'disabled?' do
      @runner.disabled?.must_equal false
    end
  end

  describe 'skip?' do
    it 'returns true if url is /ruby_prof_rails' do
      env = mock_env
      env['PATH_INFO'] = '/ruby_prof_rails'
      runner = RubyProf::Rails::Runner.new( env: env, app: mock_app )
      runner.skip?.must_equal true
    end

    it 'returns true if disabled' do
      env = mock_env
      env['rack.session'][:ruby_prof_rails][:enabled] = false
      runner = RubyProf::Rails::Runner.new( env: env, app: mock_app )
      runner.skip?.must_equal true
    end

    it 'returns true if unable to find route' do
      app = mock_app
      app.stubs(:recognize_path).returns(nil)
      runner = RubyProf::Rails::Runner.new( env: mock_env, app: app )
      runner.skip?.must_equal true
    end

    it 'returns false if valid profile url' do
      runner = RubyProf::Rails::Runner.new( env: mock_env, app: mock_app )
      runner.skip?.must_equal false
    end

    it 'returns true if js if exclude_format is nil' do
      app = mock_app
      app.stubs(:recognize_path).returns(mock_recognize_path.merge(format: 'jpeg'))
      runner = RubyProf::Rails::Runner.new( env: mock_env, app: app )
      runner.skip?.must_equal true
    end

    it 'returns true if url is a javascript file' do
      app = mock_app
      app.stubs(:recognize_path).returns(mock_recognize_path.merge(format: 'jpeg'))
      runner = RubyProf::Rails::Runner.new( env: mock_env, app: app )
      runner.skip?.must_equal true
    end

  end

  describe 'call' do
    it 'profiles code' do
      call_return_array = [200, 'text/html', 'the body']
      app = mock_app
      app.expects(:call).returns(call_return_array)
      runner = RubyProf::Rails::Runner.new( env: mock_env, app: app )
      runner.call(mock_env).must_equal call_return_array
    end
  end

  private

  def mock_env
    {
      'rack.session' => {
        ruby_prof_rails: {
          printer: RubyProf::Rails::Printer::PRINTERS.keys.first,
          enabled: true,
          exclude_formats: 'png, jpeg, js'
        }
      },
      'rack.session.options' => {
        id: SecureRandom.hex
      },
      'PATH_INFO' => '/'
    }
  end

  def mock_app
    app = FakeApp.new
    app.stubs(:recognize_path).returns(mock_recognize_path)
    app
  end

  def mock_recognize_path
    {controller: 'test', action: 'index', url: 'test', format: 'html'}
  end

end
