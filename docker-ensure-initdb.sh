#!/usr/bin/env bash
set -Eeuo pipefail

# Importe les fonctions d'initialisation
source /usr/local/bin/docker-entrypoint.sh

# S'assure que le premier argument est 'postgres'
if [ "$#" -eq 0 ] || [ "$1" != 'postgres' ]; then
  set -- postgres "$@"
fi

# Prépare l'environnement
docker_setup_env
docker_create_db_directories

# Si exécuté en tant que root, relance le script en tant qu'utilisateur postgres
if [ "$(id -u)" = '0' ]; then
  exec gosu postgres "$BASH_SOURCE" "$@"
fi

# Si la base n'existe pas encore
if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
  docker_verify_minimum_env
  docker_error_old_databases
  ls /docker-entrypoint-initdb.d/ > /dev/null
  docker_init_database_dir
  pg_setup_hba_conf "$@"
  export PGPASSWORD="${PGPASSWORD:-$POSTGRES_PASSWORD}"
  docker_temp_server_start "$@"
  docker_setup_db
  docker_process_init_files /docker-entrypoint-initdb.d/*
  docker_temp_server_stop
  unset PGPASSWORD
else
  self="$(basename "$0")"
  case "$self" in
    docker-ensure-initdb.sh)
      echo >&2 "$self: note: database already initialized in '$PGDATA'!"
      exit 0
      ;;
    docker-enforce-initdb.sh)
      echo >&2 "$self: error: (unexpected) database found in '$PGDATA'!"
      exit 1
      ;;
    *)
      echo >&2 "$self: error: unknown file name: $self"
      exit 99
      ;;
  esac
fi
# Créez le répertoire wwwroot avec les autorisations appropriées
RUN mkdir -p /app/wwwroot && \
    chown -R node:node /app/wwwroot && \
    chmod 755 /app/wwwroot
