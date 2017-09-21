tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "redis-server"
    
    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/johnromani/projects/he-web/"
    write text "gco develop"
    write text "git pull"
    write text "npm run develop"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rabbitmq-server"

    split vertically with default profile
  end tell

  tell fourth session of current tab of current window
    write text "/Users/johnromani/projects/he-public-api/"
    write text "gco develop"
    write text "git pull"
    write text "npm start"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "sidestart.sh"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rails s -b ::"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
  end tell
end tell
