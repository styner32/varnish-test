rails_root = ENV['RAILS_ROOT'] || '/opt/varnish-test/current'
directory rails_root
environment ENV['RAILS_ENV'] || 'development'
daemonize false

bind 'tcp://127.0.0.1:3000'
threads(ENV['PUMA_MIN_NUM_THREADS'] || 16, ENV['PUMA_MAX_NUM_THREADS'] || 16)
workers(ENV['PUMA_NUM_WORKERS'] || 2)

pidfile "#{rails_root}/tmp/pids/puma.pid"
state_path "#{rails_root}/tmp/pids/puma.state"
stdout_redirect "#{rails_root}/tmp/puma.stdout.log", "#{rails_root}/tmp/puma.stderr.log", true

preload_app!