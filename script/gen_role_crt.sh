#!/bin/sh
# export LD_LIBRARY_PATH=/media/app/beyonddc/lib
CERT_PATH=./cert/$serial_no
OPENSSL_PATH=openssl
DEVICE_KEY=./cert/device.key
OPENSSL_CNF=./config/openssl.cnf
CSR_REQ_CNF=./config/req.cnf
CONFIG_CSR_REQCNF=./script/config_csr_reqcnf.sh
CA_KEY=./cert/CA/ca.key
CA_CERT=./cert/CA/ca.crt

if [ ! $# -eq 4 ]
then
    echo "usage: $0 [client/server][serial number][sim ip][local ip]"
    exit 1
fi

NAME="$1"
serial_no="$2"

if [ "$NAME" = "client" ] || [ "$NAME" = "server" ]; then
	echo "$NAME"|logger
else
    echo "input param error:$NAME"|logger
	exit 1
fi

CERT_PATH=./cert/$serial_no
DEVICE_KEY=$CERT_PATH/device.key
KEY_FILE=$CERT_PATH/$NAME.key
CSR_FILE=$CERT_PATH/$NAME.csr
CERT_FILE=$CERT_PATH/$NAME.crt

if [ -f $KEY_FILE ] && [ -f $CERT_FILE ]; then
	echo "file exist ,skip"|logger
    exit 0
fi

# 生成私钥
echo "generate $NAME private key..."|logger
$OPENSSL_PATH ecparam -genkey -name prime256v1 -out $KEY_FILE
# $OPENSSL_PATH genrsa -out $KEY_FILE 1024
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME private key OK"|logger
else
    echo "generate $NAME private key ERROR"|logger
	exit $stat
fi

# 生成CSR
echo "generate CSR..."|logger
# serial_no=`echo "select serial_no from me limit 1;" | sqlite3 /media/disk/dc.db`
echo "serial_no:$serial_no"|logger
sim_ip=$3
local_ip=$4
if [  ! $local_ip ];then
	echo "local_ip is null"|logger
	exit 1
fi

if [ ! $sim_ip ];then
	echo "sim_ip is null"|logger
	exit 1
fi
echo "serial_no:$serial_no sim_ip:$sim_ip local_ip:$local_ip"|logger
$CONFIG_CSR_REQCNF SXE$serial_no $sim_ip $local_ip
$OPENSSL_PATH req -sha256 -new -key $KEY_FILE -out $CSR_FILE -config $CSR_REQ_CNF
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CSR OK"|logger
else
    echo "generate $NAME CSR ERROR"|logger
	exit $stat
fi

# 使用device.key对CSR签名
echo "generate CSR signature..."|logger
$OPENSSL_PATH dgst -sha256 -sign $DEVICE_KEY -out $CSR_FILE.sha256 $CSR_FILE
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CSR signature sha256 OK"|logger
else
    echo "generate $NAME CSR signature sha256 ERROR"|logger
	exit $stat
fi

$OPENSSL_PATH enc -base64 -in $CSR_FILE.sha256 -out $CSR_FILE.sha256.base64
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CSR signature base64 OK"|logger
else
    echo "generate $NAME CSR signature base64 ERROR"|logger
	exit $stat
fi

$OPENSSL_PATH x509 -req -days 1095 -extensions v3_req -in $CSR_FILE -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $CERT_FILE -extfile $CSR_REQ_CNF
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate $NAME CERT OK"|logger
else
    echo "generate $NAME CERT ERROR"|logger
	exit $stat
fi

exit 0