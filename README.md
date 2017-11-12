# kick-user.sh
Make link or place `kick-user.sh` to folder included in your user's PATH variable and name it to `kick`, after that you are ready to use this script, but it's really optional. If you are non-root user, you need to have `sudo` installed on system and you also need to be in sudoers group to use sudo itself.

    Usage:    kick [username] [-r|-s|-l]
    Example:  kick john
    Example:  kick john -r
    Example   kick -r john

    Flags:
      -r      Kick only remote client (ssh).
      -s      Kick from all shells (including ssh). (default)
      -l      Same as -s, but it also locks account after being kicked.

You can now change default flag inside script and it will show up in help.

### Dependencies:
* sudo

## Author
* Author: Kevin Rudissaar
* Email: kevin.rudissaar[at]gmail.com
* Twitter: [@KevinRudissaar](https://twitter.com/KevinRudissaar)

## Donate
If you found this script really useful or if you would just like to donate to developer, you can use following donation methods:

[![Donate via PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EGU5RTCF69G82)

BTC: 1HZNkcukFHYF5FKPTvsTnNQNiGQTHZcbR7
