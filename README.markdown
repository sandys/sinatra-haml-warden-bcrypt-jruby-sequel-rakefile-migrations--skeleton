bundle exec shotgun -d config.ru -E production
thin config -C /tmp/testapp.yml -c /home/user/research/test_sinatra/2  --servers 3 
thin start -C /tmp/testapp.yml
thin restart -C /tmp/testapp.yml
thin stop -C /tmp/testapp.yml
bundle exec warble compiled  executable war
bundle exec jruby --1.9 -S trinidad -r config.ru -g DEBUG -e development
