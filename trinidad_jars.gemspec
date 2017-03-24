# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = 'trinidad_jars'

  jars_rb = File.expand_path("../lib/trinidad/jars.rb", __FILE__)
  gem.version = File.read(jars_rb).match(/^\s*TRINIDAD_JARS_VERSION\s*=\s*['"](.*)['"]/)[1]

  gem.summary     = "Jars packaged for Trinidad"
  gem.description = "Bundled version of Tomcat and a slice of Java required by Trinidad."

  gem.authors  = ['David Calavera']
  gem.email    = 'calavera@apache.org'
  gem.homepage = 'https://github.com/trinidad/trinidad'
  gem.licenses = ['MIT', 'Apache-2.0']

  gem.platform = 'java'

  gem.require_paths = %w[lib] # due require 'trinidad/jars'

  gem.files = `git ls-files`.split("\n").sort.
    select { |file| file == 'trinidad_jars.gemspec' ||
                    file == 'lib/trinidad/jars.rb'  ||
                    file =~ /^trinidad-libs\// }
end
