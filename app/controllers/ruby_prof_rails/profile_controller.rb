module RubyProfRails
  class ProfileController < RubyProfRails::ApplicationController

    include ActionView::Helpers::TextHelper

    def show
      profile = RubyProf::Rails::Profiles.find(params[:id])
      if profile
        time = profile.time.strftime('%Y-%m-%d_%I-%M-%S-%Z')
        send_file profile.filename, filename: "#{profile.hash[:prefix]}_#{time}.#{profile.hash[:format]}"
      else
        render text: 'Profiler file was not found and may have been deleted.' # write some content to the body
      end
    end

    def destroy
      delete_profiles
      redirect_to redirect_with_anchor_path
    end

    def batch
      delete_profiles if params[:batch_method] = 'delete'
      redirect_to redirect_with_anchor_path
    end

    private

    def delete_profiles
      delete_profiles = Array(params[:id]).map { |id| delete_profile(id) }
      profiles = pluralize(delete_profiles.length, 'profile')
      if delete_profiles.empty?
        flash[:alert] = "No profiles selected"
      elsif delete_profiles.all?
        flash[:notice] = "#{profiles} deleted"
      else
        flash[:alert] = "#{profiles} not found"
      end
    end

    def delete_profile(id)
      profile = RubyProf::Rails::Profiles.find(id)
      return false unless profile
      File.unlink profile.manifest
      File.unlink profile.filename
      true
    end

    def redirect_with_anchor_path
      anchor = params[:tab].present? ? "##{params[:tab]}" : ''
      @routes.ruby_prof_rails_path + anchor
    end

  end
end