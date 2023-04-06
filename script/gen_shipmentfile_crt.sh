#!/bin/sh
# export LD_LIBRARY_PATH=/media/app/beyonddc/lib
# CERT_PATH=/media/app/beyonddc/cert
OPENSSL_PATH=openssl
OPENSSL_CNF=./config/shipmentfile.cnf

NAME="shipmentfile"

serial_no="$1"

CERT_PATH=./cert/shipmentfile
KEY_FILE=$CERT_PATH/$NAME.key
CERT_FILE=$CERT_PATH/$NAME.crt


# 生成CERT
echo "generate CERT..."|logger
$OPENSSL_PATH req -new -x509 -days 3650 -key $KEY_FILE -out $CERT_FILE -config $OPENSSL_CNF
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CERT OK"|logger
else
    echo "generate $NAME CERT ERROR"|logger
	exit $stat
fi

exit 0
