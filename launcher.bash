image="flask_with_mongo:py3.10.14-alpine3.20"

WEB_PORT_HTTP=80

curWorkDir=$(pwd)

# Mirage to container
APP_MAIN="main.py"
APP_FOLDER="/app"
APP_PROJECT_FOLDER="/project"
APP_DATABASE_FOLDER="/db"

SERVICE_API="api"
SERVICE_DATABASE="mongoDb"

# Host path
DIR_IMAGE="${curWorkDir}/docker_image"
DIR_APP="${curWorkDir}/app"
DIR_DATABASE="${curWorkDir}/db"
DIR_PROJECT="${curWorkDir}/project"
DIR_LOG="${DIR_PROJECT}/log"

# database
DATABASE_IMAGE="mongo:latest"
DIR_DB_SERVICE_FOLDER="${DIR_APP}/database"
DIR_DB_SOCK_FOLDER="/tmp"
DIR_DB_SOCK_FOLDER="${DIR_APP}/_ipc"
APP_DB_SERVICE_FOLDER="/data/db"
APP_DB_SOCK_FOLDER="/tmp"

function startDatabase() {
    echo "Start service ${SERVICE_DATABASE}"
    docker run --name ${SERVICE_DATABASE} \
    --interactive --detach --tty \
    -p 27017:27017 \
    -e MONGODB_INITDB_ROOT_USERNAME="" \
    -e MONGODB_INITDB_ROOT_PASSWORD="" \
    --workdir $APP_FOLDER \
    --volume ${DIR_DB_SERVICE_FOLDER}:${APP_DB_SERVICE_FOLDER} \
    --volume ${DIR_DB_SOCK_FOLDER}:${APP_DB_SOCK_FOLDER} \
    ${DATABASE_IMAGE} 
}

#

function startApi() {
    #cmd="python ${APP_MAIN} ${SERVICE_API} start"
    cmd="python ${APP_MAIN}"
    echo "Start service ${SERVICE_API}"
    docker run --name ${SERVICE_API} \
    --interactive --detach --tty \
    -p ${WEB_PORT_HTTP}:80 \
    --workdir $APP_FOLDER \
    --volume ${DIR_APP}:${APP_FOLDER} \
    --volume ${DIR_PROJECT}:${APP_PROJECT_FOLDER} \
    --volume ${DIR_DATABASE}:${APP_DATABASE_FOLDER} \
    --log-opt max-size=1m \
    ${image} ${cmd}
}

function main() {
    service=${1}

    if [[ "${service}" == "api" ]]; then
        startApi
    elif [[ "${service}" == "database" ]]; then
        startDatabase
    else
        echo "No specific service selected"
    fi
}
main ${1}