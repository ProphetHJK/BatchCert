#!/bin/sh
# export LD_LIBRARY_PATH=/media/app/beyonddc/lib
# CERT_PATH=/media/app/beyonddc/cert
OPENSSL_PATH=openssl
OPENSSL_CNF=./config/openssl.cnf

NAME="ca"

CERT_PATH=./cert/CA
KEY_FILE=$CERT_PATH/$NAME.key
CERT_FILE=$CERT_PATH/$NAME.crt

mkdir -p $CERT_PATH

if [ -f $KEY_FILE ] && [ -f $CERT_FILE ]; then
    echo "file exist ,skip"|logger
    exit 0
fi

# 生成私钥
echo "generate $NAME private key..."|logger
$OPENSSL_PATH genrsa -out $KEY_FILE 4096
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME private key OK"|logger
else
    echo "generate $NAME private key ERROR"|logger
	exit $stat
fi

# 生成CERT
echo "generate  $NAME CERT..."|logger
$OPENSSL_PATH req -new -x509 -days 3650 -key $KEY_FILE -out $CERT_FILE -subj /CN=DELGAZ_ROOT_CA_TEST/ST="Zhejiang"/L="Ningbo"/C="CN"/O="Sanxing" -config $OPENSSL_CNF
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CERT OK"|logger
else
    echo "generate $NAME CERT ERROR"|logger
	exit $stat
fi

exit 0
