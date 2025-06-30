# pterodactyl-sourcegames-git
a pterodactyl source games nest fork that introduces poor implementation of sync with github - tested on gmod only

original: https://github.com/pterodactyl/yolks/tree/master/games/source

just edit the REPO_URL url in entrypoint.sh to match your repository url and REPO_PATH to set the path where the repo will be cloned initally. when server starts for the first time - it will generate the ssh key and quit, expecting you to use that key as a deploy key in your repository. after that - it will begin automatically syncing with your repo each time you start the server.
