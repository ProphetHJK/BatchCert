#! /bin/sh
#修改strongswan配置

if [ ! $# -eq 3 ]
then
    echo "usage: $0 [serial number][sim ip][local ip]"
    exit 1
fi

serial_no="$1"
sim_ip="$2"
local_ip="$3"

REQ_CNF_PATH=./config/req.cnf

echo "CN:$serial_no IP.1:$sim_ip IP.2:$local_ip"|logger

sed -i 's#\(^CN = \).*#\1'${serial_no}'#' $REQ_CNF_PATH
sed -i 's#\(^IP.1 = \).*#\1'${sim_ip}'#' $REQ_CNF_PATH
sed -i 's#\(^IP.2 = \).*#\1'${local_ip}'#' $REQ_CNF_PATH