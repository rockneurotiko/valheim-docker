#!/bin/bash

mkdir -p "${STEAMAPPDIR}" || true
mkdir -p "${SERVER_DATA_DIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
     +login anonymous \
     +app_update "${STEAMAPPID}" \
     +quit

echo -e "${STEAM_ADMIN_ID}" > "${SERVER_DATA_DIR}/adminlist.txt"

EXTRA_PARAMS=($EXTRA_PARAMS)
CROSSPLAY=""

if [[ "${SERVER_CROSSPLAY}" == "true" ]]; then
  CROSSPLAY="-crossplay"
fi

cd "${STEAMAPPDIR}"
  
"./valheim_server.x86_64" -batchmode \
                          -nographics \
                          -screen-width "${SCREEN_WIDTH}" \
                          -screen-height "${SCREEN_HEIGHT}" \
                          -screen-quality "${SCREEN_QUALITY}" \
                          -name "${SERVER_NAME}" \
                          -port "${SERVER_PORT}" \
                          -world "${SERVER_WORLD}" \
                          -password "${SERVER_PASSWORD}" \
                          -public "${SERVER_PUBLIC}" \
                          -savedir "${SERVER_DATA_DIR}" \
                          "${CROSSPLAY}" \
                          "${EXTRA_PARAMS[@]}"
