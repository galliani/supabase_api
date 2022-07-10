# frozen_string_literal: true

require_relative "lib/supabase_api/version"

Gem::Specification.new do |spec|
  spec.name = "supabase_api"
  spec.version = SupabaseApi::VERSION
  spec.authors = ["Galih Muhammad"]

  spec.summary = "A ruby client for Supabase tables to be consumed as ruby class via the REST API"
  spec.homepage = "https://github.com/galliani/supabase_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/galliani/supabase_api"
  spec.metadata["changelog_uri"] = "https://github.com/galliani/supabase_api/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty"
end
