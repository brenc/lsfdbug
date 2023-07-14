# lsfdbug

1. Run `docker compose up`
2. In one window/tab run `docker exec -it lsfdbug-liquidsoap-1 watch -n1 'ls /proc/$(pidof liquidsoap)/fd | wc -l'`
3. In another window/tab run `openssl s_client -connect HOST:8200`
4. Hit ctrl-c. The FD count should increment
