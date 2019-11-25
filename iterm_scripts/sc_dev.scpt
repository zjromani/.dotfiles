tell application "iTerm"
  tell current session of current tab of current window
    write text "/Users/zachromani/projects/smartcapital-api/"
    write text "rails s -p 3001"

    split horizontally with default profile
  end tell

  tell second session of current tab of current window
    write text "/Users/zachromani/projects/smartcapital-web/"
    write text "gco master"
    write text "yarn start"

    split horizontally with default profile
  end tell
end tell

