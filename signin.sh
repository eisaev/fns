#!/bin/sh


# Random device ID
DEVID=`uuidgen | tr -d '-'`
# DeviceID
DEVOS="Adnroid 4.4.4"
# Protocol version
PROTO="2"
# Client version
CLIENT="1.4.1.3"
# User agent
UAGENT="okhttp/3.0.1"
# Base URL
BASE="http://proverkacheka.nalog.ru:9999"


if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ]
then
    echo "Использование: ${0} {номер телефона} {e-mail} {имя}"
    exit
fi


REQUEST="{\"phone\":\"${1}\",\"email\":\"${2}\",\"name\":\"${3}\"}"
RESULT=` curl --netrc-file ./netrc -s -H "Content-Type:application/json" -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" "${BASE}/v1/mobile/users/signup" -d "${REQUEST}"`
