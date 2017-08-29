#!/bin/sh


# Внимание! Данные для авторизации перенесены в отдельный файл. Переименуйте файл netrc.sample в netrc и укажите в нём реальные телефон и код, полученный по СМС.

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
BASE="https://proverkacheka.nalog.ru:9999"


if [ ! -z "${1}" ] && [ ! -z "${2}" ] && [ ! -z "${3}" ]
then
    #./get.sh 8710000100270243 18863 2145745075
    # Fiscal storage (Номер фискального накопителя - ФН)
    FN="${1}"
    # Fiscal document number (Номер фискального документа - ФД)
    FD="${2}"
    # Fiscal sign (Подпись фискального документа - ФП)
    FS="${3}"

    RESULT=` curl --netrc-file ./netrc -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" "${BASE}/v1/inns/*/kkts/*/fss/${FN}/tickets/${FD}" -d "fiscalSign=${FS}" -d "sendToEmail=no"`

    DT=`echo "${RESULT}" | jq -r ".document.receipt.dateTime"`
    echo "${RESULT}" | jq "." > "${DT}_${FS}.json"
else
    RESULT=`curl --netrc-file ./netrc -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" "${BASE}/v1/extract" -d "sendToEmail=0" -d "fileType=json"`

    URL=`echo "${RESULT}" | jq -r ".url"`
    RESULT=`curl --netrc-file ./netrc -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" "${BASE}${URL}"`

    DT=`date -Iseconds`
    echo "${RESULT}" | jq "." > "all_${DT}.json"
fi