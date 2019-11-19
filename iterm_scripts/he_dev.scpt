tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "brew services start rabbitmq"
    write text "brew services start redis"

    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/zachromani/projects/members/"
    write text "gco develop"
    write text "nvm use 10.13.0"
    write text "NODE_ENV=alpha PUBLIC_API_HOST=http://localhost:5000 yarn run develop"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/zachromani/projects/he-public-api/"
    write text "gco develop"
    write text "nvm use 10.13.0"
    write text "RAILS_API_HOST=http://0.0.0.0:3000 yarn develop"

    split horizontally with default profile
  end tell

  tell fourth session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "memcached -vv"

    split horizontally with default profile
  end tell

  tell fifth session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "rails s -p 2000"
  end tell

  tell current window
    create window with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "bin/sidekiq-development.sh"
    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/zachromani/projects/he-api/"
    write text "rails sneakers:run SNEAKERS_HEARTBEAT=100000000000"
  end tell
end tell
