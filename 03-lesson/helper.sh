export NODE_IP=192.168.99.100
export NODE_PORT=31265

curl http://192.168.99.100:31265/users/add/init

curl -i -H "Content-Type: application/json" -X POST -d '{"uid": "1", "user":"John Doe"}' http://192.168.99.100:31265/users/add
curl -i -H "Content-Type: application/json" -X POST -d '{"uid": "2", "user":"Jane Doe"}' http://192.168.99.100:31265/users/add
curl -i -H "Content-Type: application/json" -X POST -d '{"uid": "3", "user":"Bill Collins"}' http://192.168.99.100:31265/users/add
curl -i -H "Content-Type: application/json" -X POST -d '{"uid": "4", "user":"Mike Taylor"}' http://192.168.99.100:31265/users/add

curl http://192.168.99.100:31265/users/add/users/1


curl -i -H "Content-Type: application/json" -X POST -d '{"uid": "1", "user":"John Doe"}' http://192.168.99.100:31265/users/add