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
    wget -O plugins/Geyser-Spigot.jar https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar && \
    wget -O plugins/Floodgate-Spigot.jar https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/Floodgate-Spigot.jar

# Expone puertos de Java y Bedrock
EXPOSE 25565/tcp
EXPOSE 19132/udp

# Comando para iniciar
CMD ["java", "-Xmx3G", "-Xms1G", "-jar", "server.jar", "nogui"]
