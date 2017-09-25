#!/bin/sh


if [ -z "${1}" ]
then
    echo "Использование: ${0} {Заводской номер ККТ}"
    exit
fi

KKTTYPES=`curl -sS 'https://www.nalog.ru/Ajax.html' -H 'Origin: https://www.nalog.ru' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4' -H 'X-Compress: null' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.nalog.ru/css/check_kiz/checkKKT.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed --data "type=LoadKKT&kkt_type=kkt" | jq "." | grep -Pe "\"(code|name)\":" | sed 'N;s/\n/ /' | awk -F\" '{print $4 ";" $8}' | sed 's/ /_/g'`

for KKTTYPE in ${KKTTYPES}
do
    TYPEID=`echo ${KKTTYPE} | awk -F\; '{print $1}'`
    TYPENAME=`echo ${KKTTYPE} | awk -F\; '{print $2}'`

    RESULT=`curl -sS 'https://www.nalog.ru/Ajax.html' -H 'Origin: https://www.nalog.ru' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4' -H 'X-Compress: null' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.nalog.ru/css/check_kiz/checkKKT.html' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed --data "type=CheckKKT&kkt_type=kkt&code=${TYPEID}&number=${1}" | jq "." | grep "\"check_result\": \"Э"`
    if [ -n "${RESULT}" ]
    then
        echo ${TYPENAME} "- V"
        exit
    fi
    echo ${TYPENAME} "- X"
done

echo "Вам не повезло :("
