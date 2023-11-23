#!/bin/bash

mkdir -p "${STEAMAPPDIR}" || true
mkdir -p "${SERVER_DATA_DIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
     +login anonymous \
     +app_update "${STEAMAPPID}" \
     +quit

echo -e "${STEAM_ADMIN_ID}" > "${SERVER_DATA_DIR}/adminlist.txt"

cd "${STEAMAPPDIR}"


START_SCRIPT="start_server_bepinex.sh"

if [ ! -f "${STEAMAPPDIR}/${START_SCRIPT}" ]; then
  wget --max-redirect=30 -qO- "https://github.com/valheimPlus/ValheimPlus/releases/download/${VP_VERSION}/UnixServer.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}"
  chmod +x "${STEAMAPPDIR}/${START_SCRIPT}"
fi

if [ ! -f "${STEAMAPPDIR}/BepInEx/config/valheim_plus.cfg" ]; then
  wget --max-redirect=30 "https://raw.githubusercontent.com/valheimPlus/ValheimPlus/${VP_VERSION}/valheim_plus.cfg" -O "${STEAMAPPDIR}/BepInEx/config/valheim_plus.cfg"
fi

bash "${STEAMAPPDIR}/${START_SCRIPT}" -name "${SERVER_NAME}" \
     -port "${SERVER_PORT}" \
     -world "${SERVER_WORLD}" \
     -password "${SERVER_PASSWORD}" \
     -public "${SERVER_PUBLIC}" \
     -savedir "${SERVER_DATA_DIR}" 
