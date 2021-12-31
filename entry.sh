#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true
mkdir -p "${SERVER_DATA_DIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
     +login anonymous \
     +app_update "${STEAMAPPID}" \
     +quit

# Replace
sed -i -E 's/^\.\/valheim_server\.x86_64 .+$/\.\/valheim_server.x86_64 -name "${SERVER_NAME}" -port "${SERVER_PORT}" -world "${SERVER_WORLD}" -password "${SERVER_PASSWORD}" -public "${SERVER_PUBLIC}" -savedir "${SERVER_DATA_DIR}"/g' "${STEAMAPPDIR}/start_server.sh"

echo -e "${STEAM_ADMIN_ID}" > "${SERVER_DATA_DIR}/adminlist.txt"

cd "${STEAMAPPDIR}"

START_SCRIPT="start_server.sh"

if [ "$VALHEIM_PLUS" = "true" ]; then
  START_SCRIPT="start_server_bepinex.sh"

  if [ ! -f "${STEAMAPPDIR}/${START_SCRIPT}" ]; then
     wget --max-redirect=30 "$VPURL" -O "$VPTAR"
     tar xvf "$VPTAR" -C "$STEAMAPPDIR"
     chmod +x "${STEAMAPPDIR}/${START_SCRIPT}"
  fi

  if [ ! -f "$VPCONFIGPATH" ]; then
     wget --max-redirect=30 "$VPCONFIGURL" -O "$VPCONFIGPATH"
  fi
fi

bash "${STEAMAPPDIR}/${START_SCRIPT}" -name "${SERVER_NAME}" -port "${SERVER_PORT}" -world "${SERVER_WORLD}" -password "${SERVER_PASSWORD}" -public "${SERVER_PUBLIC}" -savedir "${SERVER_DATA_DIR}"
