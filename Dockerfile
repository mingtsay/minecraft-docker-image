FROM openjdk:17 as production

LABEL \
    maintainer="Ming Tsay <mt@mingtsay.tw>" \
    repo="https://github.com/mingtsay/minecraft-docker-image"

RUN set -eux \
    && /usr/bin/curl -sLo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && /usr/bin/chmod +x /usr/bin/jq \
    && /usr/bin/curl -sLo /var/local/version_manifest.json https://launchermeta.mojang.com/mc/game/version_manifest.json \
    && /usr/bin/curl -sLo /var/local/latest_version.json $(/usr/bin/jq -cj '[.versions[]|select(.type=="release")][0].url' /var/local/version_manifest.json) \
    && /usr/bin/curl -sLo /var/local/server.jar $(/usr/bin/jq -cj '.downloads.server.url' /var/local/latest_version.json) \
    && [ $(/usr/bin/wc -c < /var/local/server.jar) -eq $(/usr/bin/jq -cj '.downloads.server.size' /var/local/latest_version.json) ] \
    && echo "$(/usr/bin/jq -cj '.downloads.server.sha1' /var/local/latest_version.json) /var/local/server.jar" | /usr/bin/sha1sum -c -

VOLUME [ "/data" ]
ENV WORKDIR /data
WORKDIR /data
EXPOSE 25565

ENTRYPOINT [ "/usr/java/openjdk-17/bin/java" ]
CMD [ "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1NewSizePercent=30", "-XX:G1MaxNewSizePercent=40", "-XX:G1HeapRegionSize=8M", "-XX:G1ReservePercent=20", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-Xms256M", "-Xmx2G", "-jar", "/var/local/server.jar", "nogui" ]
