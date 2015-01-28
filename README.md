# Ruby-Prof Rails

## Summary

Rack middleware that allows you to easily run [ruby-prof](https://github.com/ruby-prof/ruby-prof) profiler on your rails application for your session only and not impact other users of a Rails application.

## Requirements

* Ruby 1.9.3 or higher
* Rails 3 or later (with asset pipeline enabled)
* [ruby-prof gem](https://github.com/ruby-prof/ruby-prof)
* [ruby-prof-flamegraph gem](https://github.com/oozou/ruby-prof-flamegraph)

## Install

To install, include ruby-prof-rails in your Gemfile and run bundle install:

```ruby
gem "ruby-prof-rails", :git => "git@github.com:tleish/ruby-prof-rails.git", :group => :production
```

Note: ruby-prof-rails requires production type settings (cache classes, cache view lookups, etc.), therefore it is recommended to only include the gem in production environments.

## Configure

ruby-prof-rails won't do ANYTHING until you configure it. Update your  ```config/environments/production.rb``` initializer with the following code:

```ruby
RubyProf::Rails::Config.username = "your_shared_username"
RubyProf::Rails::Config.password = "your_shared_password"
RubyProf::Rails::Config.session_auth_lambda = lambda do |session|
  session[:user_type] == :admin
end
RubyProf::Rails::Config.path = File.join(Rails.root, 'files', 'ruby-prof-rails')
```

The code above will ready ruby-prof for your rails application:

* ```RubyProf::Rails::Config.username```: (required) username for HTTP Basic authentication to access control panel and profiles
* ```RubyProf::Rails::Config.password```: (required) password for HTTP Basic authentication to access control panel and profiles
* ```RubyProf::Rails::Config.session_auth_lambda```: (optional) lambda to check user session for specific parameters.  True allows access control panel and profiles, false will not.
* ```RubyProf::Rails::Config.path```: (optional) File location where profiles are saved (defaults to ```Rails.root/tmp/ruby-prof-rails/```).

## Routes

(Optional) Mount the gem by adding the following to ```config/routes.rb```:

```ruby
mount RubyProf::Rails::Engine, :at => '/' if Rails.env.production?
```

## Usage

Once installed and configured, run your application and navigate to ```http://your_app/ruby_prof_rails```, enter profiling options and press the ```Start Profiling``` button

![ruby-prof-rails run](https://raw.githubusercontent.com/tleish/ruby-prof-rails/master/doc/ruby_prof_rails_start.png)

### Option: Printers

Select one or more printers to save the output of your profile results.

See:

* [ruby-prof](https://github.com/ruby-prof/ruby-prof#printers)
* [ruby-prof-flamegraph](https://github.com/oozou/ruby-prof-flamegraph#ruby-prof-flamegraph)

### Option: Measurement

see [ruby-prof Measurements](https://github.com/ruby-prof/ruby-prof#measurements)

### Option: Eliminate Method Patterns

see [ruby-prof Method Elimination](https://github.com/ruby-prof/ruby-prof#method-and-thread-elimination)

eliminate_methods is a list of regular expressions (line separated text).
```
Integer#times
String#.*
```

### Option: Exclude Request Route Formats:

ruby-prof-rails supports excluding specific request file formats from the routes.

For example, you likely want to skip images (png, jpg, gif), unless you are producing these images via rails code.

exclude_formats is a list of file formats (line separated text).

```
css, js, json, map, jpg, jpeg, png, gif
```

Any routes with the file formats specified will be ignored and skipped over.

### Stop Profiling:

When profiling is complete, press the stop button to see profiling results

![ruby-prof-rails stop](https://raw.githubusercontent.com/tleish/ruby-prof-rails/master/doc/ruby_prof_rails_stop.png)

### Profiles

* My Profiles: Profiles captured from your current session.
* All Profiles: Profiles captured from all sessions.

![ruby-prof-rails My Profiles](https://raw.githubusercontent.com/tleish/ruby-prof-rails/master/doc/ruby_prof_rails_profiles.png)


## License

See MIT-LICENSE for further details.