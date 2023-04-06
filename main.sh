#!/bin/sh
DATA_CSV=data/data.csv

# 生成CA证书
script/gen_ca.sh
stat=$?
if [ $stat -eq 0 ]; then
	echo "generate ca CERT OK"
else
    echo "generate ca CERT ERROR"
	exit $stat
fi

# 变量信息文件读取表号
LINE=0
IFS=,
cat $DATA_CSV | while read serial_no sim_ip local_ip
do
    LINE=$(expr $LINE + 1)
    echo line:$LINE'\t'serial_no:$serial_no'\t'sim_ip:$sim_ip'\t'local_ip:$local_ip
    mkdir -p ./cert/$serial_no
    script/gen_device_crt.sh $serial_no
    script/gen_role_crt.sh client $serial_no $sim_ip $local_ip
    script/gen_role_crt.sh server $serial_no $sim_ip $local_ip
    script/rm_csr.sh $serial_no
done

