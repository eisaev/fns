#!/bin/sh

# Phone number
PHONE="+79876543210"
# Password from SMS
PASS="123123"
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

    RESULT=` curl -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" -u "${PHONE}:${PASS}" "${BASE}/v1/inns/*/kkts/*/fss/${FN}/tickets/${FD}" -d "fiscalSign=${FS}" -d "sendToEmail=no"`

    DT=`echo "${RESULT}" | jq -r ".document.receipt.dateTime"`
    echo "${RESULT}" | jq "." > "${DT}_${FS}.json"
else
    RESULT=`curl -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" -u "${PHONE}:${PASS}" "${BASE}/v1/extract" -d "sendToEmail=0" -d "fileType=json"`

    URL=`echo "${RESULT}" | jq -r ".url"`
    RESULT=`curl -s -G -X GET -H "Device-Id: ${DEVID}" -H "Device-OS: ${DEVOS}" -H "Version: ${PROTO}" -H "ClientVersion: ${CLIENT}" -A "${UAGENT}" -u "${PHONE}:${PASS}" "${BASE}${URL}"`

    DT=`date -Iseconds`
    echo "${RESULT}" | jq "." > "all_${DT}.json"
fi