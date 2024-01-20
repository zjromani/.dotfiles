#!/bin/bash

echo "Closing Alfred..."
killall "Alfred"

sleep 2

echo "Reopening Alfred..."
open -a "Alfred 5"

echo "Alfred should now be restarted."

