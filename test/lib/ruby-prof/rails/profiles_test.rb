# require 'minitest/autorun'
# require 'minitest/rails'
require 'test_helper'
require './lib/ruby-prof/rails/profiles'
require 'digest/sha1'
require 'fileutils'

describe RubyProf::Rails::Profiles do

  before do
    @profiles = create_random_profiles
  end

  after do
    cleanup_profiles
  end

  describe 'self.list' do
    it 'returns and array or profile objects' do
      @profiles.must_be_instance_of Array
      @profiles.first.must_be_instance_of RubyProf::Rails::Profiles
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
      filename = filename_from(30)
      filename.must_be_instance_of String
    end

    it 'starts with the prefix' do
      filename = filename_from(30)
      filename.must_match /^#{RubyProf::Rails::Profiles::PREFIX}.*/
    end
  end

  describe 'profile' do
    it 'has properties' do
      profile = @profiles.first
      profile.must_respond_to :basename
      profile.must_respond_to :friendly_filename
      profile.must_respond_to :id
      profile.must_respond_to :exists?
    end

    it 'has a hash property' do
      @profiles.first.hash.must_be_instance_of Hash
      @profiles.first.hash[:prefix].must_equal RubyProf::Rails::Profiles::PREFIX
    end
  end

  private

  def create_random_profiles
    RubyProf::Rails::Config.path = 'test/tmp'
    (1..10).each do |num|
      FileUtils.touch(RubyProf::Rails::Config.path + filename_from(num))
    end
    RubyProf::Rails::Profiles.list
  end

  def cleanup_profiles
    RubyProf::Rails::Profiles.list.each do |profile|
      File.unlink profile.filename
    end
  end

  def filename_from(num)
    RubyProf::Rails::Profiles.hash_to_filename(
      prefix: RubyProf::Rails::Profiles::PREFIX,
      time: Time.now.to_i,
      session_id: Digest::SHA1.hexdigest(num.to_s),
      url: '?url=test' + num.to_s,
      format: RubyProf::Rails::Printer::PRINTERS.values.uniq.sample
    )
  end
end
