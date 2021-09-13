#! /bin/bash
domain="${1}"

echo "以域名${domain}编译ngrok"

cd /usr/local/

apt-get install -y git golang openssl

sleep 1

git clone https://github.com/inconshreveable/ngrok.git

sleep 1

cd ngrok/
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=${domain}" -days 5000 -out rootCA.pem
openssl genrsa -out tunnel.key 2048
openssl req -new -key tunnel.key -subj "/CN=tunnel.${domain}" -out tunnel.csr
openssl x509 -req -in tunnel.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out tunnel.crt -days 5000
cp rootCA.pem assets/client/tls/ngrokroot.crt
cp tunnel.crt assets/server/tls/snakeoil.crt
cp tunnel.key assets/server/tls/snakeoil.key
echo 'generate key ok !'

sleep 1

# 编译生成linux 64bit(mac可以直接用)版本
GOOS=linux GOARCH=amd64 make release-all
# 编译生成linux 32bit(mac可以直接用)版本
GOOS=linux GOARCH=386 make release-all
# 编译生成linux arm(mac可以直接用)版本
GOOS=linux GOARCH=arm make release-all
# 编译生成windows 64bit版本
GOOS=windows GOARCH=amd64 make release-all
# 编译生成windows 32bit版本
GOOS=windows GOARCH=386 make release-all 
echo 'build ok !'

sleep 1
ngrok=`pwd`"/bin/ngrok"

ngrokd=`pwd`"/bin/ngrokd"

ln -s "${ngrok}" /usr/bin
ln -s "${ngrokd}" /usr/bin

sleep 1

echo "server_addr: tunnel.${domain}:4443" >> bin/ngrok.yml
echo "trust_host_root_certs: false"       >> bin/ngrok.yml

echo "generate ngrok.yml ok !"
