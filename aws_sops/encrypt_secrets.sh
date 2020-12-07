#! /bin/bash
for f in roles/k3s_deploy/files/secrets_decrypted/*.yaml; 
    do sops -e $f > roles/k3s_deploy/files/secrets/${f##*/}; 
done