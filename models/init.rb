# encoding: utf-8
require 'sequel'
# DB = Sequel.postgres 'dbname', user:'bduser', password:'dbpass', host:'localhost'
# DB << "SET CLIENT_ENCODING TO 'UTF8';"

puts "SSS #{@@env}"

Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case @@env.to_sym
  when :development then Sequel.connect("jdbc:postgresql://localhost/padrino?user=pad_user&password=pad_user")
  when :production  then Sequel.connect("postgres://localhost/fastjob_production",  :loggers => [logger])
  when :test        then Sequel.connect("postgres://localhost/fastjob_test",        :loggers => [logger])
end

require_relative 'user'
