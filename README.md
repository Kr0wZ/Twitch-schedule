Bash script that allows you to retrieve the schedule of any Twitch streamer using the Twitch API.
This script is just a small part of a bigger tool that will come in the future 👀

# How does it work?

On Twitch, streamers can indicate when they'll be livestreaming. This can be done using a schedule directly included in the Twitch interface.
From Twitch, the schedule for a channel can be retrieved from the following URL: https://www.twitch.tv/<CHANNEL_NAME>/schedule

With this script you can retrieve a schedule for a specific channel only by giving a Twitch username.

The username is converted into an ID (using the API). This ID is then used to get information about the schedule (also though the API).
The script shows the schedule as an iCalendar. 

You can redirect the output to a file if you want to save it.

---
# Prerequisites

To run this script you must register an application at https://dev.twitch.tv:
- Create a Twitch account or sign in with an existing one
- Activat the multiple factor authentication (2FA), else you won't be able to create an application.
- Go to https://dev.twitch.tv/console/apps/create, create a new application. Give the name you want (must be unique). Set the OAuth redirect to `https://127.0.0.1/`. Choose a random category.
- A `Client ID` is generated. You'll need it to run the script.
- Browse to this URL to generate an OAuth token: https://id.twitch.tv/oauth2/authorize?client_id=CLIENT_ID&redirect_uri=REDIRECT_URL&response_type=token&scope=SCOPE
- You must modify some fields inside this URL such as:
  - CLIENT_ID -> The Client ID you just generated in the previous step.
  - REDIRECT_URL -> The URL we specified previously -> `https://127.0.0.1/`
  - SCOPE -> A scope for your application. In our case there is no special need. You can specify `read:chat`. You can find a list of all scopes here: https://dev.twitch.tv/docs/authentication/scopes
- You will be redirected to https://127.0.0.1/ and the bearer token will appear in the URL as `access_token`. THIS TOKEN IS STRICLY PRIVATE, DO NOT SHARE IT WITH ANYONE!

Insert the Client ID and OAuth token in the corresponding variables in the script: `$CLIENT_ID` and `$OAUTH_TOKEN`.

The steps are explained in my article: https://blog.synoslabs.com/osint/2022/12/06/osint-on-twitch.html#messages

---
# Installation

Make sure to have read the prerequisites above.

The `jq` package is needed if not already installed: 
```bash
sudo apt update
sudo apt install jq
```

You are no ready to use the tool!

---
# Resources

This tool has been created while writing my article: https://blog.synoslabs.com/osint/2022/12/06/osint-on-twitch.html

Twitch Documentation:
- https://dev.twitch.tv/docs/api/reference#get-channel-icalendar
- https://dev.twitch.tv/docs/authentication/getting-tokens-oidc
- https://dev.twitch.tv/console/apps/create

iCalendar specification: https://datatracker.ietf.org/doc/html/rfc5545
