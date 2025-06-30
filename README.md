# pterodactyl-sourcegames-git
a pterodactyl source games nest fork that introduces poor implementation of sync with github - only for gmod :/

original: https://github.com/pterodactyl/yolks/tree/master/games/source

just edit the REPO_PATH url in entrypoint.sh to match your repository path. when server starts for the first time - it will generate the ssh key and quit, expecting you to use that key as a deploy key in your repository. after that - it will begin automatically syncing with your repo each time you start the server.
