tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "brew services start rabbitmq"
    write text "brew services start redis"

    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/johnromani/projects/he-web/"
    write text "gco develop"
    write text "git pull"
    write text "NODE_ENV=alpha PUBLIC_API_HOST=http://localhost:5000 yarn run develop"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/johnromani/projects/he-public-api/"
    write text "gco master"
    write text "git pull"
    write text "yarn start"

    split horizontally with default profile
  end tell

  tell fourth session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rails s"

    tell application "System Events" to tell process "iTerm2" to keystroke "m" using command down
  end tell

  tell current window
    create window with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "bin/sidekiq-development.sh"
    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rake sneakers:run SNEAKERS_HEARTBEAT=100000000000"
  end tell

  tell current window
    create window with default profile
  end tell

  tell current session of current tab of current window
    write text "dots"
    write text "gl"
    write text "/Users/johnromani/projects/he-api/"
    write text "gss"
    write text "mvim"
  end tell
end tell
