# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ricepaper}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lee Hinman"]
  s.date = %q{2009-06-10}
  s.default_executable = %q{ricepaper}
  s.description = %q{Ricepaper is a library that allows you to add URLs to Instapaper, either by using it as a CLI or as a Ruby library.}
  s.email = %q{lee@writequit.org}
  s.executables = ["ricepaper"]
  s.extra_rdoc_files = [
    "README.txt"
  ]
  s.files = [
    "ricepaper.gemspec",
    "Rakefile",
    "VERSION",
    "README.txt",
    "bin/ricepaper",
    "lib/ricepaper.rb",
  ]
  s.homepage = %q{http://github.com/dakrone/ricepaper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{writequit}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A small library for adding URLs to Instapaper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
