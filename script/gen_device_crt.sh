#!/bin/sh
# export LD_LIBRARY_PATH=/media/app/beyonddc/lib
# CERT_PATH=/media/app/beyonddc/cert
OPENSSL_PATH=openssl
OPENSSL_CNF=./config/openssl.cnf

NAME="device"

if [ ! $# -eq 1 ]
then
    echo "usage: $0 [serial number]"
    exit 1
fi

serial_no="$1"

CERT_PATH=./cert/$serial_no
KEY_FILE=$CERT_PATH/$NAME.key
CERT_FILE=$CERT_PATH/$NAME.crt

# if [ -f $KEY_FILE ] && [ -f $CERT_FILE ]; then
#     echo "file exist ,skip"|logger
#     if [ ! -f $CERT_FILE.base64 ];then
#         # 生成CERT
#         echo "generate CERT base64..."|logger
#         $OPENSSL_PATH enc -base64 -in $CERT_FILE -out $CERT_FILE.base64
#         stat=$?
#         if [ $stat -eq 0 ]; then
#             echo "generate $NAME CERT_FILE base64 OK"|logger
#         else
#             echo "generate $NAME CERT_FILE base64 ERROR"|logger
#             exit $stat
#         fi
#     fi
#     exit 0
# fi

# 生成私钥
if [ -f $KEY_FILE ]; then
    echo "file exist ,skip generate private key"|logger
else
    echo "generate $NAME private key..."|logger
    $OPENSSL_PATH genrsa -out $KEY_FILE 1024
    stat=$?
    if [ $stat -eq 0 ]; then
        echo "generate $NAME private key OK"|logger
    else
        echo "generate $NAME private key ERROR"|logger
        exit $stat
    fi
fi

# 生成CERT
if [ -f $CERT_FILE ]; then
    echo "file exist ,skip generate cert"|logger
else
    echo "generate CERT..."|logger
    $OPENSSL_PATH req -new -x509 -days 3650 -key $KEY_FILE -out $CERT_FILE -subj /CN=SXE$serial_no/ST="Zhejiang"/L="Ningbo"/C="CN"/O="SANXING" -config $OPENSSL_CNF
    stat=$?
    if [ $stat -eq 0 ]; then
        echo "generate $NAME CERT OK"|logger
    else
        echo "generate $NAME CERT ERROR"|logger
        exit $stat
    fi

    # CERT转为base64
    echo "generate CERT base64..."|logger
    $OPENSSL_PATH enc -base64 -in $CERT_FILE -out $CERT_FILE.base64
    stat=$?
    if [ $stat -eq 0 ]; then
        echo "generate $NAME CERT_FILE base64 OK"|logger
    else
        echo "generate $NAME CERT_FILE base64 ERROR"|logger
        exit $stat
    fi
fi

exit 0