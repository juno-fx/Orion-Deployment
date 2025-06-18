
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.3

###  🚀 New Features 

#### Kuiper
- Workstation endpoint has been updated. Kuberenetes Pod and Statefulset events will now be included with our workstation objects. Helping provide debugging information for each instance.
- Workstation logs endpoint added. Kubernetes logs now accessible via new endpoint for each individual instance. Helping provide debugging information for each instance.
- PREFIX path added to support [Helios](https://github.com/juno-fx/Helios)

#### Hubble
- Auto workstation catalog filtering based on user group assignment added
- Admin workstation catalog Filter components added for specific filtering
- LDAP nextauth provider support added
- Workstation details dropdown added. Providing tabs for Events and Logs for each active instance. Admins also have the ability to see events/logs for all active instances. While non-admin users can only see theirs.


### 🐛 Bug Fixes

#### Hubble

- Fixed an error with the main monitor attempting to go full screen
- Fixed an issue where locking the workstation resolution was reverting back on reconnect
- Fixed a webRTC upd bug

### 🧰  Maintenance

#### Hubble

- Adjusted workstation catalog card sizing
- Cleaned up console errors
- Updated to latest Juno branding

## Usage

This describes a full deployment of Orion. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

## Demo Setup

This is for demo purposes only. Please do not use this in production.

## Prerequisites

- [devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [helm](https://helm.sh/docs/intro/quickstart/)
- [Docker](https://github.com/docker/docker-install?tab=readme-ov-file#dockerdocker-install)
    - On linux, make sure to follow the post-installation steps [here](https://docs.docker.com/engine/install/linux-postinstall/).

## Setup

The official Orion-Deployment repository contains the necessary files to deploy the demo version of Orion.

1. Clone the Orion-Deployment repository.

    ```shell
    git clone https://github.com/juno-fx/Orion-Deployment.git
    ```

2. Change to the Orion-Deployment directory.

    ```shell
    cd Orion-Deployment
    ```

## Checkout Orion Deployment Version

The Orion-Deployment repository contains branches for each version of Orion that we have released. These are the
official Helm charts that we use to deploy Orion. To try out a specific version of Orion, you can checkout the
corresponding branch.

1. Get all deployment branches and checkout the branch for the version that you want to try.

    ```shell
    $ git fetch --all
    $ git --no-pager branch --all | grep remotes/origin/v
    remotes/origin/v1.0
    remotes/origin/v1.1
    remotes/origin/v1.2
    $ git checkout v1.2
    ```

2. Activate the devbox environment.

    ```shell
    devbox shell
    ```

## Configure Deployment

The deployment ships with a default `.values.yaml.example` file that provides all the necessary
configuration options. We need to copy this file and make any necessary changes.

1. Copy the default `.values.yaml.example` file.

    ```shell
    cp .values.yaml.example .values.yaml
    ```

2. The following fields are required
    * `registry`: Registry URL where the Juno images you loaded should be. If you do not know what this is, follow the guid [here](images.md).
    * `imagePullSecrets`: * If the registry requires credentials, the demo will create an `imagePullSecret` based on your own docker credentials called `juno-credentials`. To enable this, uncomment out the `imagePullSecrets` in the `.values.yaml` file.

## Launch Orion

Now that Orion is configured, we are ready to deploy it.

1. Run the following command to deploy Orion.

    ```shell
    make orion
    ```

   !!! info "Average Deployment Time"

        This process can take sometimes 2 - 5 minutes to complete depending on your local hardware.

   !!! success "Orion Ready"

        Orion will be ready for use once the deployment process is complete.

        ```
         ❯ make orion
         Creating cluster "orion" ...
         ✓ Ensuring node image (kindest/node:v1.32.0) 🖼
         ✓ Preparing nodes 📦 📦
         ✓ Writing configuration 📜
         ✓ Starting control-plane 🕹️
         ✓ Installing CNI 🔌
         ✓ Installing StorageClass 💾
         ✓ Joining worker nodes 🚜
         Set kubectl context to "kind-orion"
         You can now use your cluster with:
         
         kubectl cluster-info --context kind-orion
         
         Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
         Installing NGINX Ingress...
         Installing Orion...
         Release "orion" does not exist. Installing it now.
         coalesce.go:289: warning: destination for juno-orion.hubble.env is a table. Ignoring non-table value ([])
         NAME: orion
         LAST DEPLOYED: Thu Jan 30 23:39:16 2025
         NAMESPACE: default
         STATUS: deployed
         REVISION: 1
         TEST SUITE: None
         Waiting for Orion to settle...
         pod/hubble-7489784b8d-dxzgn condition met
         Orion ready...
         NAME                      READY   STATUS              RESTARTS   AGE
         cache-64d57c7f7d-p7rp8    1/1     Running             0          19s
         hubble-7489784b8d-dxzgn   1/1     Running             0          19s
         kuiper-64d5955596-gq7dc   0/1     ContainerCreating   0          19s
         terra-689975698-zsvq4     0/1     ContainerCreating   0          19s
         titan-7c55b7d6f6-gxjjz    1/1     Running             0          19s
        ```

2. Access Orion at `https://dmo.localhost/`
3. The default credentials are email: `juno@juno-innovations.com` and password: `juno`.

## Launch Our First Workstation

Now that Orion is up and running, we can launch our first workstation.

1. Modify the `juno/workstation.yaml` file and update the tag, registry and repo that points to your Polaris image.
   ```yaml
   apiVersion: juno-innovations.com/v2
   kind: Workstation
   metadata:
      name: user
   spec:
      registry: <YOUR REGISTRY>
      tag: <YOUR IMAGE TAG>
      repo: <YOUR IMAGE REPOSITORY>
      icon: "https://junovfx.com/dog.png"
      label: "User Workstation"
      group: "Production"
      cpu: "1"
      memory: "1Gi"
      mode: "interactive"
   ```

2. Apply the workstation template.
   ```shell
    kubectl apply -f juno/workstation.yaml
   ```

3. Access the kuiper dashboard at `https://dmo.localhost/workstations`
4. Click "Request" at the top left of the page.
5. If everything worked properly, you should see a workstation appear in the list of workstations.
6. Click "Launch" to start the workstation.
7. Wait for the workstation to show a Connect button.

### Clean Up

1. Delete the Orion deployment
```bash
make down
```

