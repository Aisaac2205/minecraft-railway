# Imagen base con Java 21 (requerido para Minecraft 1.21.1)
FROM eclipse-temurin:21-jdk-jammy

# Variables del entorno
ENV EULA=TRUE
ENV MEMORY=3G
ENV VERSION=1.21.1
ENV TYPE=PAPER

# Crea el directorio del servidor
WORKDIR /server

# Descarga PaperMC
RUN apt update && apt install -y wget unzip && \
    wget https://api.papermc.io/v2/projects/paper/versions/${VERSION}/builds/50/downloads/paper-${VERSION}-50.jar -O server.jar && \
    echo "eula=${EULA}" > eula.txt

# Instala plugins de Geyser y Floodgate
RUN mkdir -p plugins && \
    wget -O plugins/Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot && \
    wget -O plugins/Floodgate-Spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

# Copia configuración de Geyser
COPY geyser-config.yml /server/plugins/Geyser-Spigot/config.yml

# Expone puertos de Java y Bedrock
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Comando para iniciar
CMD ["java", "-Xmx3G", "-Xms1G", "-jar", "server.jar", "nogui"]
