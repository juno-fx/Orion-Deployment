
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.1

### New Features

- **Product Selection** - Using the chart, you can now dynamically select which products you want to deploy.
  - **Terra** - You can now control deployment of Terra using the `terra.enabled` flag in the values.yaml file.
  - **Kuiper** - You can now control deployment of Kuiper using the `kuiper.enabled` flag in the values.yaml file.
  - **Luna** - You can now control deployment of Luna using the `luna.enabled` flag in the values.yaml file.
- **Global Volume Definitions** - Volumes are now defined at the root of the values.yaml and are automatically shared amongst Terra, Mars and Webb.
  - **Workstation Automount** - Volumes are now automatically mounted to the workstation pods.
- **Kuiper** - Kuiper overall improvements.
  - **Dynamic Environment Variables** - You can now request workstations to use certain environment variables adhoc via the API only. (UI coming soon)
  - **Multi-Config Versioning** - There is now a v2 for the Workstation CRD so you can include workstation resource limits dynamically. (UI coming soon)
  - **Custom Workstation Names** - You can request a custom name for your workstation use the API. (UI coming soon)
- **Hubble** - Hubble overall improvements.
  - **Significant Performance Improvements** - Thanks to the hard work by @Anthonygen1, Hubble now has significant performance improvements and optimizations.
  - **Dropped Support for Dynamic Workstation Creation** - The workstation catalog can now only be modified via crd definitions in kubernetes. This is in preparation for global definition sharing in Genesis in the future.
  - **Service Status** - Hubble will now detect what products are enabled and only show those services in the UI. This includes hiding certain parts of the UI that are not relevant based on Orion's configuration.
- **Polaris** - Polaris overall improvements.
  - **Boot Times** - Thanks to the awesome work being done by @ddesmond, Polaris now boots significantly faster.
  - **Healthcheck** - Polaris now has a healthcheck endpoint that can be used to determine if the service is running. Before this would cause hubble to say the workstation was ready when it really wasn't
- **API Support** - API Tokens are now respected and ready for general use.
  - **API Token Generation** - You can now generate API tokens using the UI. Read about how to get started [here](https://juno-fx.github.io/Orion-Documentation/api/getting_started/)!

### Breaking Changes

- **Volume Mounting** - Volumes are now defined at the root of the values.yaml file. This means that you will need to move your volume definitions that were in Webb and Mars to the new volumes definition location at the root of the values.yaml file.


### Related Tickets

- https://github.com/juno-fx/report/issues/354
- https://github.com/juno-fx/report/issues/258
- https://github.com/juno-fx/report/issues/248
- https://github.com/juno-fx/report/issues/364
- https://github.com/juno-fx/report/issues/231

## Usage

This describes a full deployment of Orion. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).

## Demo Setup

This is for demo purposes only. Please do not use this in production.

### Prerequisites

- [devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [helm](https://helm.sh/docs/intro/quickstart/)
- [docker](https://github.com/docker/docker-install?tab=readme-ov-file#dockerdocker-install)

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
git checkout v1.1
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

