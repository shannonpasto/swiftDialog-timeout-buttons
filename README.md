# swiftDialog with specified timeout buttons and capture user response
This script will launch [swiftDialog](https://github.com/bartreardon/swiftDialog) with a custom timeout for enabling buttons 1 and 2 and also allow you to capture the response. Unlike the `--timer` with `--button1disabled` options the swiftDialog won't quit automatically. 

The script does not need any further modifications, just download and run to test. How you use it is up to you<br><br>
**Use case**<br>
You want to display swiftDialog with a custom timeout on making the button(s) active and you would also like to capture (and respond to) the button clicked by the user. In my case users aren't really reading a macOS Ventura upgrade message any more and instead just clicking later. With this script the message will be displayed with a random timeout between 5 and 15 seconds then wait for the user to choose an option and either proceed or not proceed. Using pure swiftDialog the window will quit after the specified time (`--timer`) and with `--button1disabled` the button is only disabled for the first 3 seconds.

**Caveats**
- due to the way shell works with child processes you can not use `/usr/local/bin/dialog`
- because we are not using `/usr/local/bin/dialog` we need to ensure that swiftDialog launches correctly when the script is run as root. We do this using `launchtl`
- if the swiftDialog is quit or the user clicks the info button before the sleep delay ends the script continues until the delay ends. This does not affect the result in any way. If I find a way around this I'll update the script
