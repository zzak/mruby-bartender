MRUBY_CONFIG=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")

file :mruby do
  sh "git clone --depth 1 git://github.com/mruby/mruby.git"
end

desc "compile binary"
task :compile => :mruby do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake all"
end

desc "recompile"
task :recompile => [:mruby, :tidy, :compile]

desc "test"
task :test => :mruby do
  sh "cd mruby && MRUBY_CONFIG=#{MRUBY_CONFIG} rake test"
end

desc "cleanup"
task :clean do
  sh "cd mruby && rake deep_clean"
end

desc "tidy"
task :tidy do
  sh "cd mruby && rake clean"
end
