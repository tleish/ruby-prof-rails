require 'test_helper'
require_relative 'profiles_mock_module'

describe RubyProf::Rails::Profiles do
  include RubyProf::Rails::ProfilesMockModule

  before do
    @request = mock_request
    @profiles = create_random_profiles
  end

  after do
    cleanup_profiles
  end

  describe 'self.list' do
    it 'returns and array or profile objects' do
      @profiles.must_be_instance_of Array
      @profiles.first.must_be_instance_of RubyProf::Rails::Profile
    end
  end

  describe 'self.find' do
    it 'returns true when it finds a file with a matching id' do
      RubyProf::Rails::Profiles.find(@profiles.first.id)
    end

    it 'returns false when it does not find a file with a matching id' do
      RubyProf::Rails::Profiles.find('bogus')
    end
  end

  describe 'self.hash_to_filename' do
    it 'returns a string' do
      filename = hash_to_filename
      filename.must_be_instance_of String
    end

    it 'starts with the prefix' do
      filename = hash_to_filename
      filename.must_match /^#{RubyProf::Rails::Profiles::PREFIX}.*/
    end
  end

end
