# 自动批量生成自签名证书SHELL脚本

## 证书签发流程

1. 生成CA根证书
2. 生成device自签名根证书
3. 生成client和server角色的CSR
4. 使用CA证书签发client/server角色证书

## 文件描述

```console
.
├── config --------------------- 目录：存放配置文件
│   ├── openssl.cnf ------------ openssl默认配置文件，无需配置
│   └── req.cnf ---------------- CSR请求配置文件，无需手动配置
├── data ----------------------- 目录：存放数据文件
│   └── data.csv --------------- 存放设备相关参数信息，用于CSR附加字段
├── script --------------------- 目录：存放shell脚本文件
│   ├── config_csr_reqcnf.sh --- 自动配置req.cnf脚本
│   ├── gen_ca.sh -------------- 生成ca私钥与证书
│   ├── gen_device_crt.sh ------ 生成device私钥与证书
│   └── gen_role_crt.sh -------- 生成各角色私钥、CSR与证书
├── main.sh -------------------- 主脚本
├── .gitignore ----------------- git过滤文件
└── README.md ------------------ 本文件
```
