desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I lib -r cogi_email.rb'
end
