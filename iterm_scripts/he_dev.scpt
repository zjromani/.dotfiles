tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "redis-server"
    
    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/johnromani/projects/he-web/"
    write text "yarn"
    write text "npm run develop"
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
    write text "rails s"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "pghe"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
  end tell
end tell
