require 'yaml'
require_relative 'config'
require_relative 'printer'
require_relative 'runner_button'

module RubyProf
  module Rails
    class Runner

      MEASUREMENTS = {
        PROCESS_TIME: :default,
        WALL_TIME: 'Wall Time',
        CPU_TIME: 'CPU Time',
        ALLOCATIONS: 'Allocation',
        MEMORY: 'Memory Usage',
        GC_RUNS: 'Garbage Collection',
        GC_TIME: 'Garbage Collection Time'
      }

      def initialize(options = {})
        @env = options.fetch(:env)
        @app = options.fetch(:app)
        @options = RubyProf::Rails::Config.extract_options_from @env
      end

      def enabled?
        @options[:enabled]
      end

      def disabled?
        !enabled?
      end

      def skip?
        is_config_uri? || disabled? || !is_valid_route?
      end

      def call(env)
        ruby_prof_start
        status, headers, body = @app.call(env)
        ruby_prof_stop
        ruby_prof_save if body.present? && valid_format?(headers['Content-Type'].split('/').last)
        RunnerButton.new(response: [status, headers, body]).draw
      end

      private

      def is_valid_route?
        begin
          route = ::Rails.application.routes.recognize_path(@env['REQUEST_PATH'])
          route.present? && valid_format?(route[:format])
        rescue ActionController::RoutingError
          false
        end
      end

      def is_config_uri?
        (@env['PATH_INFO'] =~ %r{/ruby_prof_rails}).present?
      end

      def valid_format?(type)
        exclude_formats = @options[:exclude_formats].to_s.split(',').map(&:strip)
        !exclude_formats.include?(type)
      end

      def ruby_prof_start
        RubyProf.measure_mode = get_measurement
        RubyProf.start
      end

      def ruby_prof_stop
        @results = RubyProf.stop
      end

      def ruby_prof_save
        eliminate_methods
        @printers = write_printers
        write_manifests
      end

      def eliminate_methods
        return unless @results.present? && @options[:eliminate_methods].present?
        eliminate_methods_regex = Array(@options[:eliminate_methods]).map { |regex| Regexp.new regex }
        @results.eliminate_methods!(eliminate_methods_regex)
      end

      def get_measurement
        measurement = MEASUREMENTS.invert[@options[:measurement]] || MEASUREMENTS.invert[:default]
        "RubyProf::#{measurement}".constantize
      end

      def write_printers
        return [] unless @results.present?
        printer = RubyProf::Rails::Printer.new(env: @env)
        printer.print(@results)
      end

      def write_manifests
        path = RubyProf::Rails::Config.path
        Dir.mkdir(path) unless ::File.exists?(path)
        @printers.each do |printer|
          filename = File.join(path, "#{printer[:filename]}.yml")
          ::File.open(filename, 'w+') do |file|
            file.write printer.to_yaml
          end
        end
      end

    end
  end
end
