begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "ricepaper"
    gemspec.summary = "A small library for adding URLs to Instapaper"
    gemspec.email = "lee@writequit.org"
    gemspec.homepage = "http://github.com/dakrone/ricepaper"
    gemspec.description = "Ricepaper is a library that allows you to add URLs to Instapaper, either by using it as a CLI or as a Ruby library."
    gemspec.authors = ["Lee Hinman"]
    gemspec.rubyforge_project = 'writequit'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/ricepaper/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

