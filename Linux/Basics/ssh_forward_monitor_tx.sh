#! /bin/sh
# 腾讯vps远程端口转发命令监控程序，用于启动并监测ssh -CqfTnN ....命令
host="tx.vps"
user="ubuntu"

while true
do
  NUM=`netstat -napt |grep ESTABLISHED |grep 140.143.224.225 |wc -l`
  echo $NUM > /tmp/txvps
  if [ "${NUM}" -lt "1" ]; then
    echo "a"
    ssh -CqfTnN -R 2222:127.0.0.1:22 ${user}@${host}
  elif [ "${NUM}" -gt "1" ]; then
    echo "b"
    killall -9 ssh
    ssh -CqfTnN -R 2222:127.0.0.1:22 ${user}@${host}
  fi
  sleep 10
done

exit 0
