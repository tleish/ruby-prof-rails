module RubyProfRails
  class ProfileController < RubyProfRails::ApplicationController

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
      profile = RubyProf::Rails::Profiles.find(params[:id])
      if profile
        File.unlink profile.filename
        flash[:notice] = 'Profile deleted'
      else
        flash[:alert] = 'Profile not found'
      end
      redirect_to controller: 'home', action: 'index'
    end

  end
end