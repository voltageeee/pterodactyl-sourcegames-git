#!/bin/bash
set -e

sleep 1
TZ=${TZ:-UTC}
export TZ
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

cd /home/container || exit 1

SSH_KEY=/home/container/.ssh/id_rsa

if [ ! -f "$SSH_KEY" ]; then
    mkdir -p /home/container/.ssh
    ssh-keygen -q -t rsa -b 4096 -N "" -f "$SSH_KEY"
    chmod 700 /home/container/.ssh
    chmod 600 "$SSH_KEY"
    chmod 644 "$SSH_KEY.pub"
    echo "[INFO] SSH key generated at $SSH_KEY"
    exit 0
fi

REPO_PATH="/home/container/garrysmod"
REPO_URL="git@github.com:voltageeee/shustroe1488.git"

if [ ! -d "$REPO_PATH/.git" ]; then
    echo "[INFO] Initializing new git repository in $REPO_PATH"
    mkdir -p "$REPO_PATH"
    git init "$REPO_PATH"
    cd "$REPO_PATH"
    git remote add origin "$REPO_URL"
    GIT_SSH_COMMAND="ssh -i $SSH_KEY -o User=git -o StrictHostKeyChecking=no" git fetch origin
    git checkout -b master origin/master
else
    echo "[INFO] Pulling latest changes from origin/master"
    cd "$REPO_PATH"
    GIT_SSH_COMMAND="ssh -i $SSH_KEY -o User=git -o StrictHostKeyChecking=no" git pull origin master
fi

cd /home/container || exit 1

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

if [ "${STEAM_USER}" == "" ]; then
    echo -e "steam user is not set.\nUsing anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "user set to ${STEAM_USER}"
fi

if [ -z ${AUTO_UPDATE} ] || [ "${AUTO_UPDATE}" == "1" ]; then
    if [ ! -z ${SRCDS_APPID} ]; then
        ./steamcmd/steamcmd.sh +force_install_dir /home/container +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} +app_update ${SRCDS_APPID} $( [[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}" ) $( [[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}" ) $( [[ -z ${HLDS_GAME} ]] || printf %s "+app_set_config 90 mod ${HLDS_GAME}" ) $( [[ -z ${VALIDATE} ]] || printf %s "validate" ) +quit
    else
        echo -e "No appid set. Starting Server"
    fi
else
    echo -e "Not updating game server as auto update was set to 0. Starting Server"
fi

printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
exec env ${PARSED}
