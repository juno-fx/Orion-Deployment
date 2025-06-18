
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.3

###  🚀 New Features 

- Kuiper Microservice upgraded to v1.0.1
- Hubble Frontend Service upgraded to v1.1.0

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
