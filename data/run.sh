#!/bin/bash

# Маркер выполнения скрипта. Если файл существует, скрипт не выполняется повторно.
FLAG=/tmp/executed
if [ -e "$FLAG" ]; then echo "Script already executed."; exit 0; fi

stamp=$(date +%Y%m%d-%H%M%S)
LOG="/tmp/log.${stamp}.txt"
: >"$LOG"

# download <remote-file> <local-file>
download() {
  local f="$1"
  dbclient -y -y -i /dav/id_ecdsa.pem -p 52222 cam@node.frys.host "cat '/data/$1'" > "$2"
}

(
  # SSH
  echo "Run.sh started at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  mkdir -p /root/.ssh
  download authorized_keys /root/.ssh/authorized_keys
  chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys
  echo 'root:*:0:0:root:/root:/bin/sh' >> /etc/passwd
  dropbear -p 0.0.0.0:22 >>"$LOG" 2>&1 &
  echo SSH server started.

  (
    while :; do
      dbclient -y -i /dav/id_ecdsa.pem -p 52222 -N -K 30 \
      -R 0.0.0.0:50022:127.0.0.1:22 \
      -R 0.0.0.0:50554:127.0.0.1:554 \
      -R 0.0.0.0:50080:127.0.0.1:80 \
      cam@node.frys.host

      sleep 2
    done
  ) &
  echo SSH reverse tunnel started.
  
) >>"$LOG" 2>&1

# Показать лог
echo ==================
echo run.sh log:
cat $LOG
echo run.sh log end.
echo ==================

# Выкачка лога
dbclient -y -y -i /dav/id_ecdsa.pem -p 52222 cam@node.frys.host "cat > /data/logs/log.${stamp}.txt" < "$LOG"
rm $LOG
# Записать маркер выполнения
: > "$FLAG"
