# tidal_offline
Use the TIDAL API to enable offline listening

## How to use
* Make a request with your TIDAL username and password as defined in `sync.sh`. This request will give you your `SESSION_ID` and your `USER_ID`.
* Copy `vars.sh.example` to `vars.sh`.
* Enter your `SESSION_ID` and `USER_ID` into `vars.sh`. (Also update the `TARGET_DIR` if you want.)
* Run `sync.sh`. (You can set it up with a cron job if you want.)
