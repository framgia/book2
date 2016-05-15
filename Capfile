require 'capistrano/setup'
require 'capistrano/deploy'

require "capistrano/rails"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "rvm1/capistrano3"
require "capistrano/bundler"
# require "capistrano/sidekiq"
require "capistrano3/unicorn"
require "capistrano/faster_assets"
require "whenever/capistrano"

Dir.glob("lib/capistrano/tasks/*.rake").each{|r| import r}
