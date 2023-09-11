#!/bin/bash

PROJECT_PATH="my_project_path/"

SONAR_TOKEN="my_sonar_project_token"
SONAR_PROJECT_KEY="my_sonar_project_key"
SONAR_VERSION="8.9-community"

MAVEN_CLI_OPTS="-B --batch-mode --errors -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"

analyse=false
start=false

while getopts "as" opt
do
    case $opt in
    (a) analyse=true ; echo "You chose to analyse the project" ;;
    (s) start=true ; echo "You chose to start Sonar" ;;
    (*) printf "Illegal option '-%s'\n" "$opt" && exit 1 ;;
    esac
done

if [ "$start" = true ]
then
    echo "🐳 Récupération de l'image Sonar..."

    docker pull sonarqube:$SONAR_VERSION

    docker volume create --name sonarqube_data

    docker stop sonarqube

    docker rm sonarqube

    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube_data:/opt/sonarqube/data sonarqube:$SONAR_VERSION

    echo "⏳ En attente du démmarage de Sonar..."

    while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9000)" != "200" ]]; do sleep 5; done

    echo "✅ Sonar démarré !"

    open http://localhost:9000
fi

if [ "$analyse" = true ]
then
    echo "🔍 Démarrage de l'analyse de $PROJECT_PATH !"

    cd $PROJECT_PATH

    export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
    
    mvn $MAVEN_CLI_OPTS clean compile verify sonar:sonar -Dsonar.coverage.jacoco.xmlReportPaths=./target/site/jacoco/jacoco.xml -U -Dsonar.sourceEncoding=UTF-8 -Dsonar.scm.disabled=true -Dsonar.qualitygate.wait=true -Dsonar.login=${SONAR_TOKEN} -Dsonar.projectKey=${SONAR_PROJECT_KEY} -Dsonar.projectName=${SONAR_PROJECT_KEY} -Dsonar.projectVersion=local -Dsonar.host.url="http://localhost:9000"
fi

echo "✅ Terminé !"
