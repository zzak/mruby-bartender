MRuby::Build.new do |conf|
  toolchain :gcc

  enable_debug
  conf.gem File.expand_path(File.dirname(__FILE__))
end
