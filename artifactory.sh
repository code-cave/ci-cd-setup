#/usr/bin/env sh

# This script performs the setup for
# a JFrog Artifactory Docker container.
set -euo pipefail

printf "Starting Artifactory Docker container setup ...\n\n"
# The local data directory for the Docker volume
data_dir=${HOME}/jfrog/artifactory/var

# Create the local data directory and config file
mkdir -p ${data_dir}/etc
printf "Created Artifactory directory:     ${data_dir}/etc\n"
touch ${data_dir}/etc/system.yaml
printf "Created Artifactory system config: ${data_dir}/etc/system.yaml\n\n"

# Get the user id and group id
uid_gid=$(id | cut -d ' ' -f1 -f2)
uid=$(echo ${uid_gid} | cut -d ' ' -f1 | cut -d '=' -f2 | cut -d '(' -f1)
gid=$(echo ${uid_gid} | cut -d ' ' -f2 | cut -d '=' -f2 | cut -d '(' -f1)

# Set data directory owner and file mode
chown -R ${uid}:${gid} ${data_dir}
printf "Artifactory directory ownership set to: ${uid}:${gid} ${data_dir}\n"
chmod -R 777 ${data_dir}
printf "Artifactory directory file mode set to: 777 ${data_dir}\n\n"

# Create the Artifactory container
artifactory_image="releases-docker.jfrog.io/jfrog/artifactory-oss:latest"

printf "Pulling Artifactory image ${artifactory_image} ...\n"
docker pull ${artifactory_image}

printf "\nCreating Artifactory container ...\n"
docker run -d \
  --name artifactory \
  -v ${data_dir}/:/var/opt/jfrog/artifactory \
  -p 8081:8081 \
  -p 8082:8082 \
  ${artifactory_image}

printf "\nArtifactory now available at: http://localhost:8082/ui\n"
printf "Username: admin\n"
printf "Password: password\n\n"

exit 0

