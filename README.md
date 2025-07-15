
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/)

## Deployment Chart v1.3.1

###  🚀 New Features 

- Kuiper Microservice upgraded to v2.0.0 (Major)
- Hubble Frontend Service upgraded to v2.0.0 (Major)

#### Kuiper
- Add plugin support via configmap
- Added edit endpoints to requested more resources for running instance
- Dynamic chart loading for workstations
- Handling user control requests updates

#### Hubble
- Share workstation UI updates
- Events table columns now adjustabled, events message no wraps.
- Kuiper permissions updated. Users assigned to the Kuiper role will now have the admin controls for workstation launching/controlling. They will also have access to the API.
Previously users had to be in the Kuiper role to access the workstations table and launch workstations. This is no longer the case. All users with access to the project can now launch workstations. Kuiper users have the expanding permissions.

### 🐛 Bug Fixes

#### Hubble

- Admin and Kuiper users will have the ability to connect workstations
- LDAP support with self-signed CAs

#### Kuiper
- Helm install workaround for upstream Helm issue with larger UIDs
- Proper threading for our workstation data fetching
- Scope down ingress allowing hubble to handle the auth

### 🧰  Maintenance

#### Hubble

- Removed inactive users from admin workstation request options
- Capability added for hubble to act as basic auth proxy
- custom Kasm settings have been removed.
- Proper error handling for bad data fetches
- Metrics widget removed
- Delete conditional added to ensure users cannot try to connect to a workstation while it's deleting
- Cleaned up data fetching techniques
- Removed share and control options for headless workstations
- Provide a clear error message when a users license limit is reached

## Usage

This describes a full deployment of Orion. For a more detailed guide, please see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/installation/deployments/).
