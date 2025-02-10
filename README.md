
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.2

### New Features

- **Product Selection** - Using the chart, you can now dynamically select which products you want to deploy.
  - **Terra** - You can now control deployment of Terra using the `terra.enabled` flag in the values.yaml file.
  - **Kuiper** - You can now control deployment of Kuiper using the `kuiper.enabled` flag in the values.yaml file.
  - **Luna** - You can now control deployment of Luna using the `luna.enabled` flag in the values.yaml file.

### Breaking Changes

- **Volume Mounting** - Volumes are now defined at the root of the values.yaml file. This means that you will need to move your volume definitions that were in Webb and Mars to the new volumes definition location at the root of the values.yaml file.


### Related Tickets

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

5. Copy the values.yaml file
```bash
cp values.yaml .values.yaml
```

6. Fill out the .values.yaml file with the appropriate values

7. Launch Orion (Sometime there is a race condition with NGINX. If this fails, just try again)
```bash
make orion
```

8. Access Orion at `https://<what ever you filled in the "host" value with in the values file>`

### Clean Up

1. Delete the Orion deployment
```bash
make down
```

