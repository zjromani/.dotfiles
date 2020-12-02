tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "brew services start rabbitmq"
    write text "brew services start redis"

    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/zachromani/projects/members/"
    write text "nvm use 10.13.0"
    write text "PORT=8000 NODE_ENV=alpha PUBLIC_API_HOST=http://localhost:5000 yarn run develop"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "memcached -vv"

    split horizontally with default profile
  end tell

  tell fourth session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "rails s -p 3001"
    split horizontally with default profile
  end tell

  tell fifth session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "bin/sidekiq-development.sh"
    split horizontally with default profile
  end tell

  tell sixth session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "rails sneakers:run SNEAKERS_HEARTBEAT=100000000000"
    split horizontally with default profile
  end tell

  tell seventh session of current tab of current window
    write text "/Users/zachromani/projects/he-public-api/"
    write text "nvm use"
    write text "RATES_API_URL=http://localhost:3000 RAILS_API_HOST=http://0.0.0.0:3001 yarn dev"
    split horizontally with default profile
  end tell

  tell eighth session of current tab of current window
    write text "/Users/zachromani/projects/rates-api"
    write text "nvm use"
    write text "RAILS_API_HOST=localhost:3001 SEND_ESRS_TO_HE_API=true PORT=3000 yarn dev"
  end tell
end tell

