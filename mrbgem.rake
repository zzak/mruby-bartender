MRuby::Gem::Specification.new('mruby-bartender') do |spec|
  spec.license = 'MIT'
  spec.authors  = %w(seki zzak)
  spec.summary = 'Async I/O'

  # Core dependencies
  spec.add_dependency 'mruby-string-ext', core: 'mruby-string-ext'
  spec.add_dependency 'mruby-numeric-ext', core: 'mruby-numeric-ext'
  spec.add_dependency 'mruby-array-ext', core: 'mruby-array-ext'
  spec.add_dependency 'mruby-fiber', core: 'mruby-fiber'

  # mgem dependencies
  spec.add_dependency 'mruby-uv', mgem: 'mruby-uv'
  spec.add_dependency 'mruby-io', mgem: 'mruby-io'
end
