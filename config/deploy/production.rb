set :rails_env, :production
set :whenever_roles, :whenever
set :server, "deploy@#{ENV["SERVER"]}"

role :web, %W{#{fetch :server}}
role :app, %W{#{fetch :server}}
role :db, %W{#{fetch :server}}
role :whenever,  %W{#{fetch :server}}

# server ENV["SERVER"], user: "deploy", roles: %w{web app db whenever}

set :ssh_options, {
  keys: %w(/home/deploy/.ssh/id_rsa),
  forward_agent: true,
}
