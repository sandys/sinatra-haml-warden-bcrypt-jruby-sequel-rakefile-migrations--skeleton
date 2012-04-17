#bundle exec jruby --1.9 -S trinidad -r config.ru -g DEBUG -e development 
#run for migrations 
bundle exec jruby --1.9 -S rake db:migrate:up 

#run for development with good stack traces
bundle exec jruby --1.9 -S rackup
