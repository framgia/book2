# config valid only for Capistrano 3.1
require 'rvm1/capistrano3'
lock '3.4.1'

set :application, 'book2'
set :repo_url, 'git@github.com:framgia/book2.git'
set :deploy_to, '/usr/local/rails_apps/book2'

set :scm, :git
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads
  public/download public/mail_log_attachments public/output_form_log}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5
set :rvm_type, :system
set :rvm1_ruby_version, "2.3.1"

set :pid_file, "#{shared_path}/tmp/pids/unicorn.pid"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
     invoke "unicorn:restart"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

#  desc "Upload database.yml"
#  task :upload do
#    on roles(:app) do |host|
#      if test "[ ! -d #{shared_path}/config ]"
#        execute "mkdir -p #{shared_path}/config"
#      end
#      upload!("config/database.yml", "#{shared_path}/config/database.yml")
#    end
#  end
#  before :starting, 'deploy:upload'

end
