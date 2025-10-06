# Imagen base con Java 17
FROM openjdk:17-jdk-slim

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

# Expone puertos de Java y Bedrock
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Crea configuración de Geyser para usar el mismo puerto
RUN mkdir -p plugins/Geyser-Spigot/config && \
    echo "bedrock:" > /tmp/geyser-config.yml && \
    echo "  port: 25565" >> /tmp/geyser-config.yml && \
    echo "  address: 0.0.0.0" >> /tmp/geyser-config.yml

# Comando para iniciar
CMD ["java", "-Xmx3G", "-Xms1G", "-jar", "server.jar", "nogui"]
