module "k3s" {
    source  = "xunleii/k3s/module"
    k3s_version = "v1.19.4+k3s1"

    servers = {
        kube00 = {
            ip = "192.168.8.100"
            connection = {
                type = "ssh"
                host = "192.168.8.100"
                user = "pi"
            }
            flags = [
                "--write-kubeconfig-mode 644",
                "--no-deploy servicelb",
                "--no-deploy traefik"
            ]
        }
    }
    agents = {
        
        kube01 = {
            ip = "192.168.8.101"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.101"
            }
        },
        
        kube02 = {
            ip = "192.168.8.102"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.102"
            }
        },
        kube03 = {
            ip = "192.168.8.103"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.103"
            }
        },
        kube04 = {
            ip = "192.168.8.104"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.104"
            }
        },
        kube05 = {
            ip = "192.168.8.105"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.105"
            }
        },
        kube08 = {
            ip = "192.168.8.108"
            connection = {
                type = "ssh"
                user = "pi"
                host = "192.168.8.108"
            }
        }
    }
}

resource null_resource get_kubeconfig {
    depends_on = [module.k3s]
  provisioner "local-exec" {
    command = "scp pi@192.168.8.100:/etc/rancher/k3s/k3s.yaml kubeconfig"
  }
}

resource null_resource fix_kubeconfig {
    depends_on  = [null_resource.get_kubeconfig] 
    provisioner "local-exec" {
        command = "sed -i '' 's/127.0.0.1/192.168.8.100/g' kubeconfig"
    }
}

resource null_resource move_kubeconfig {
    depends_on  = [null_resource.fix_kubeconfig] 
    provisioner "local-exec" {
        command = "cp kubeconfig ~/.kube/config"
    }
}
