Hiwatch camera handler.
Reverse proxy to get rtsp stream, ssh, http access using camera->server connection
(uses some hacks)
u need to patch your initrun.sh, using ch341a, binwalk, dd, squashfs.
and add that:
```sh
echo 'Frys was here'

echo "#!/bin/sh" > /bin/shellplz
echo '/bin/sh -c sh' >> /bin/shellplz
chmod 755 /bin/shellplz
ln -s /bin/shellplz /bin/showServer # gives u root

run() {
    dbclient -y -y -i /dav/id_ecdsa.pem -p 52222 cam@server 'cat /data/run.sh' | bash
}

(
	sleep 30
	
	while ! ping -c1 -W1 8.8.8.8 2>&1; do sleep 10; done

	run
    sleep 120
    
    while true; do run || :; sleep 3600; done 
) &

exit 0
```

to get more info about this just contact me in telegram @frysuni