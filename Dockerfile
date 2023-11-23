###########################################################
# Dockerfile that builds a Valheim Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

LABEL maintainer="miguelglafuente@gmail.com"

ENV STEAMAPPID 896660
ENV STEAMAPP valheim
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-server"

# Create autoupdate config
# Remove packages and tidy up

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
        && chown -R "${USER}:${USER}" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
        # Cleanup
        && rm -rf /var/lib/apt/lists/*

COPY entry.sh "${HOMEDIR}/entry.sh"
COPY entry_plus.sh "${HOMEDIR}/entry_plus.sh"

RUN chmod +x "${HOMEDIR}/entry.sh" "${HOMEDIR}/entry_plus.sh" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/entry_plus.sh"

FROM build_stage AS base

ENV SERVER_NAME="My awesome server" \
    SERVER_PORT=2456 \
    SERVER_WORLD="Dedicated" \
    SERVER_PASSWORD="1234secret!" \
    SERVER_PUBLIC=1 \
    SERVER_DATA_DIR="${STEAMAPPDIR}/data" \
    SERVER_CROSSPLAY="true" \
    STEAM_ADMIN_ID="" \
    SCREEN_QUALITY="Fastest" \
    SCREEN_WIDTH=640 \
    SCREEN_HEIGHT=480 \
    EXTRA_PARAMS=""

USER ${USER}

VOLUME ${STEAMAPPDIR}

WORKDIR ${HOMEDIR}

FROM base AS main

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 2456/udp \
        2457/udp \
        2458/udp

FROM base AS plus

ENV VP_VERSION="0.9.9.11" \
    SERVER_WORLD="DedicatedPlus"

CMD ["bash", "entry_plus.sh"]

# Expose ports
EXPOSE 2456/udp \
    2457/udp \
    2458/udp
