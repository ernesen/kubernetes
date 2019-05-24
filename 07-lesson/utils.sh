#/bin/bash

function create_user() 
{
    NAME=$1
    GROUP=$2
    openssl genrsa -out $NAME.key 2048
    openssl req -new -key $NAME.key -out $NAME.csr -subj "/CN=$NAME/O=$GROUP"
    openssl x509 -req -in $NAME.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out $NAME.crt -days 500
}
