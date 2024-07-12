#!/bin/bash

REPO_NAME=$1
REPO_URL=$2
BRANCH_NAME=$3
REPO_DIR="/s3bucket/scripts_repo/$REPO_NAME/$BRANCH_NAME/"
LOG_FILE="/tmp/git_sync.log"

# Limpa o arquivo de log anterior
> $LOG_FILE

# Função de log
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "Starting git sync operation."

# Verifica se o diretório existe e contém um repositório Git
if [ -d "$REPO_DIR/.git" ]; then
    log "Directory exists. Checking out branch $BRANCH_NAME and pulling latest changes."
    cd "$REPO_DIR"
    git fetch origin >> $LOG_FILE 2>&1
    git checkout "$BRANCH_NAME" >> $LOG_FILE 2>&1
    git pull origin "$BRANCH_NAME" >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
        log "Error during git pull"
        exit 1
    else
        log "Git pull completed successfully"
    fi
else
    log "Directory does not exist. Cloning repository and checking out branch $BRANCH_NAME."
    mkdir -p "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR" >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
        log "Error during git clone"
        exit 1
    else
        cd "$REPO_DIR"
        git checkout "$BRANCH_NAME" >> $LOG_FILE 2>&1
        if [ $? -ne 0 ]; then
            log "Error checking out branch $BRANCH_NAME"
            exit 1
        fi
        log "Git clone and checkout completed successfully"
    fi
fi

log "Git sync operation completed."
