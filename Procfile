web: bundle exec puma -t 1:1 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -q default -q mailers -C config/sidekiq.yml -e production