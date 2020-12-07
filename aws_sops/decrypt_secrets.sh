#! /bin/bash
mkdir -p ../roles/k3s_deploy/files/secrets_decrypted; 
for f in ../roles/k3s_deploy/files/secrets/*.yaml; 
    do sops -d $f > ../roles/k3s_deploy/files/secrets_decrypted/${f##*/}; 
done