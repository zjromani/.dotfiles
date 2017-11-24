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
    write text "docker run -p 8000:8000 he-web:latest"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/johnromani/projects/he-public-api/"
    write text "gco develop"
    write text "git pull"
    write text "npm run develop"
  end tell

  tell current window
    create window with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "sidestart.sh"
    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rails s"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "gss"
  end tell
end tell
