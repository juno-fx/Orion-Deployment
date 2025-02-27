
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.2

### New Features

- **New Multi-Role Node Support** - You can now define multiple roles for a node. This allows you to have a node that is both a workstation and a headless node.
  - **`juno-innovations.com/workstation: "true"`** - This label is used to define that a Node can support workstation deployments.
  - **`juno-innovations.com/headless: "true"`** - This label is used to define that a Node can support headless deployments.
  - **Backwards Compatibility** - The older `junovfx.com/node: "workstation"` and `junovfx.com/node: "render"` labels are still supported, but will be deprecated soon.
- **Service Label Migration** - All services now use the `juno-innovations.com/service` label to protect critical services from being overloaded with workstation/headless workloads.
- **Major Kuiper Scheduling Updates** - Kuiper now supports new scheduling preferences.
  - **Headless Scheduling Compression** - If a headless service is launched, it will first check if there are any nodes tagged as headless. If there is a node tagged as both a workstation and a headless node, it will prefer another node that is exclusively a headless node. If none is available, it will use the workstation node assuming there is room.
- **`juno-innovations.com/v1` CRD's** - To better match the Juno brand, we have migrated all CRD's to use the `juno-innovations.com/v{1,2}` API groups.
  - **Kuiper Global CRD's** - Workstation definitions have been promoted to the cluster level so they can be globally available to other Orion installs.
  - **Titan Global CRD's** - User and Group definitions have been promoted to the cluster level so they can be globally available to other Orion installs.
- **Hubble Updates** - Hubble has received minor updates.
  - **Remote Control** - Remote control other users machines if you have been granted the admin group.
- **Genesis Deployment Manager** - This deployment is now configured to prefer deployment with Genesis.
  - **Genesis Deployment** - Genesis is a new deployment manager that is designed to be a more robust deployment manager for Orion.

### Breaking Changes

- **CRD Migration** - All existing CRD's will need to be migrated to the new `juno-innovations.com/v{1,2}` API groups from the older `junovfx.com/v1` API Groups. If this is not done, existing CRD's will not be able to be used. In the future we intend to provide migration methods for these kinds of changes.


### Related Tickets

- **CRD Migration** - [https://github.com/juno-fx/titan/issues/44](https://github.com/juno-fx/titan/issues/44), [https://github.com/juno-fx/kuiper/issues/112](https://github.com/juno-fx/kuiper/issues/112)

## Usage

This describes a full deployment of Orion. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

## Demo Setup

This is for demo purposes only. Please do not use this in production.

### Prerequisites

- [devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [helm](https://helm.sh/docs/intro/quickstart/)
- [docker](https://github.com/docker/docker-install?tab=readme-ov-file#dockerdocker-install)
  - On linux, make sure to follow the post-installation steps [here](https://docs.docker.com/engine/install/linux-postinstall/).

### Setup

1. Clone the Orion-Deployment repository
```bash
git clone https://github.com/juno-fx/Orion-Deployment.git
```

2. Change into the directory
```bash
cd Orion-Deployment
```

3. Change to the branch you want to deploy
```bash
git checkout v1.2
```

4. Activate devbox
```bash
devbox shell
```

5. Copy the .values.yaml.example file
```bash
cp .values.yaml.example .values.yaml
```

6. Fill out the .values.yaml file with the appropriate values
    * Add the registry you uploaded your juno images to.
    * If it requires credentials, you will need to add an imagePullSecret manually and then add it here.

7. Launch Orion (Sometime there is a race condition with NGINX. If this fails, just try again)
```bash
make orion
```

8. Access Orion at `https://dmo.localhost/`

### Clean Up

1. Delete the Orion deployment
```bash
make down
```

