# HA-KUBE

Kubernetes-based home automation, media, and monitoring platform

## Setup an external database to enable High-Availability

* TODO

## Building the Cluster

The cluster can be built using an ansible playbook. The playbook installs [k3s](https://k3s.io) on each server and agent.

1. Set up host entries for `k3s_firstnode` (the first node to be installed), `k3s_servers`, and `k3s_agents`.
2. Create the cluster with:

    ```Shell
    ansible-playbook cluster_setup/cluster_init.yml
    ```

3. Deploy everything to the cluster with:

    ```Shell
    ./setup_cluster.sh
    ```

## Tearing down the Cluster

The k3s cluster can be completely torn down using an ansible playbook. It will also remove the `kine` table from the Postgres database.

```Shell
ansible-playbook cluster_setup/cluster_teardown.yml
```

## Useful Links

* [Building multi-arch docker images](https://docs.docker.com/docker-for-mac/multi-arch/)
* [Fix namespace stuck in "Terminating" state](https://medium.com/@clouddev.guru/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e)

## Useful Commands

Getting all completed job pods

```Shell
kubectl get pod --field-selector=status.phase==Succeeded
```

Deleting all completed job pods

```Shell
kubectl delete pod --field-selector=status.phase==Succeeded
```
