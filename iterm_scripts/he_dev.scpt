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
    write text "docker build -t he-web ."
    write text "docker run -p 8000:8000 he-web:latest"

    split horizontally with default profile
  end tell

  tell third session of current tab of current window
    write text "/Users/johnromani/projects/he-public-api/"
    write text "gco master"
    write text "git pull"
    write text "npm run develop"
    tell application "System Events" to tell process "iTerm2" to keystroke "m" using command down
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
    write text "rake sneakers:run SNEAKERS_HEARTBEAT=100000000000"
  end tell

  tell current window
    create tab with default profile
  end tell

  tell current session of current tab of current window
    write text "/Users/johnromani/projects/he-api/"
    write text "rails s"
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
