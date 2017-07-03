#!/bin/sh

# Phone number
PHONE="+79876543210"
# Password from SMS
PASS="123123"

BASE="http://proverkacheka.nalog.ru:8888"

if [ ! -z "${1}" ] && [ ! -z "${2}" ] && [ ! -z "${3}" ]
then
    #./get.sh 8710000100270243 18863 2145745075
    # Fiscal storage (Номер фискального накопителя - ФН)
    FN="${1}"
    # Fiscal document number (Номер фискального документа - ФД)
    FD="${2}"
    # Fiscal sign (Подпись фискального документа - ФП)
    FS="${3}"

    RESULT=` curl -s -G -X GET -H "Device-Id: 1234567890abcdef" -H "Device-OS: Gumanoid 42" -H "Version: 2" -H "ClientVersion: 1.4.1.3" -A "okhttp/3.0.1" -u "${PHONE}:${PASS}" "${BASE}/v1/inns/*/kkts/*/fss/${FN}/tickets/${FD}" -d "fiscalSign=${FS}" -d "sendToEmail=no"`

    DT=`echo "${RESULT}" | jq -r ".document.receipt.dateTime"`
    echo "${RESULT}" | jq "." > "${DT}_${FS}.json"
else
    RESULT=`curl -s -G -X GET -H "Device-Id: 1234567890abcdef" -H "Device-OS: Gumanoid 42" -H "Version: 2" -H "ClientVersion: 1.4.1.3" -A "okhttp/3.0.1" -u "${PHONE}:${PASS}" "${BASE}/v1/extract" -d "sendToEmail=0" -d "fileType=json"`

    URL=`echo "${RESULT}" | jq -r ".url"`
    RESULT=`curl -s -G -X GET -H "Device-Id: 1234567890abcdef" -H "Device-OS: Gumanoid 42" -H "Version: 2" -H "ClientVersion: 1.4.1.3" -A "okhttp/3.0.1" -u "${PHONE}:${PASS}" "${BASE}${URL}"`

    DT=`date -Iseconds`
    echo "${RESULT}" | jq "." > "all_${DT}.json"
fi