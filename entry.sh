#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true
mkdir -p "${SERVER_DATA_DIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous \
     +force_install_dir "${STEAMAPPDIR}" \
     +app_update "${STEAMAPPID}" \
     +quit

# Replace
sed -i -E 's/^\.\/valheim_server\.x86_64 .+$/\.\/valheim_server.x86_64 -name "${SERVER_NAME}" -port "${SERVER_PORT}" -world "${SERVER_WORLD}" -password "${SERVER_PASSWORD}" -public "${SERVER_PUBLIC}" -savedir "${SERVER_DATA_DIR}"/g' "${STEAMAPPDIR}/start_server.sh"

echo "${STEAM_ADMIN_ID}" > "${SERVER_DATA_DIR}/adminlist.txt"

cd "${STEAMAPPDIR}"

bash "${STEAMAPPDIR}/start_server.sh"
