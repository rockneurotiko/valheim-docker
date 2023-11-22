###########################################################
# Dockerfile that builds a Valheim Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="miguelglafuente@gmail.com"

ENV STEAMAPPID 896660
ENV STEAMAPP valheim
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-server"
ENV VPURL https://github.com/valheimPlus/ValheimPlus/releases/download/0.9.9/UnixServer.tar.gz
ENV VPTAR "${STEAMAPPDIR}/UnixServer.tar.gz"
ENV VPCONFIGURL https://raw.githubusercontent.com/valheimPlus/ValheimPlus/0.9.9/valheim_plus.cfg
ENV VPCONFIGPATH "${STEAMAPPDIR}/BepInEx/config/valheim_plus.cfg"

# Create autoupdate config
# Add entry script & ESL config
# Remove packages and tidy up
COPY entry.sh "${HOMEDIR}/entry.sh"

RUN set -x \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                wget \
                ca-certificates \
                lib32z1 \
                file \
                libpulse-dev \
                libatomic1 \
                libc6 \
        && mkdir -p "${STEAMAPPDIR}" \
        && { \
                echo '@ShutdownOnFailedCommand 1'; \
                echo '@NoPromptForPassword 1'; \
                echo 'login anonymous'; \
                echo 'force_install_dir '"${STEAMAPPDIR}"''; \
                echo 'app_update '"${STEAMAPPID}"''; \
                echo 'quit'; \
           } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
        && chmod +x "${HOMEDIR}/entry.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
        # VALHEIM PLUS
        && wget --max-redirect=30 "$VPURL" -O "$VPTAR" \
        && chown steam "$VPTAR" \
        && su steam -c 'tar xvf "$VPTAR" -C "$STEAMAPPDIR"' \
        && rm "$VPTAR" \
        && chmod +x "${STEAMAPPDIR}/start_server_bepinex.sh" \
        && wget --max-redirect=30 "$VPCONFIGURL" -O "$VPCONFIGPATH" \
        && chown steam "$VPCONFIGPATH" \
        # Cleanup
        && rm -rf /var/lib/apt/lists/*

ENV SERVER_NAME="My awesome server" \
    SERVER_PORT=2456 \
    SERVER_WORLD="Dedicated" \
    SERVER_PASSWORD="1234secret!" \
    SERVER_PUBLIC=1 \
    SERVER_DATA_DIR="${STEAMAPPDIR}/data" \
    STEAM_ADMIN_ID="" \
    VALHEIM_PLUS="false"

USER ${USER}

VOLUME ${STEAMAPPDIR}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 2456/udp \
        2457/udp \
        2458/udp