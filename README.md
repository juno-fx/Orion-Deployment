
![Orion Logo](https://juno-fx.github.io/Orion-Documentation/genesis5.2.0-orion4.3.0/assets/logos/orion/orion-dark.png)

[Read the full documentation here](https://juno-fx.github.io/Orion-Documentation/genesis5.2.0-orion4.3.0)

## Deployment Chart v4.2.0

This deployment chart includes the release images for Hubble (v6.3.0), Kuiper (v4.3.0), and Rhea (v1.2.3).

See all the latest feature changes via our Changelogs [here](https://juno-fx.github.io/Orion-Documentation/genesis5.2.0-orion4.3.0/changelogs/feature/#2026-07-12)

A summary of all deprecations, migration steps between major versions and addressed security vulnerabilities is kept [in our technical changelog here](https://juno-fx.github.io/Orion-Documentation/genesis5.2.0-orion4.3.0/changelogs/technical/#2026-07-12-genesis-v520-orion-projects-v430).

---

## Ingress Controllers

This chart has been tested with these ingress controllers:

- [Kubernetes ingress-nginx](https://kubernetes.github.io/ingress-nginx/) (default)
- [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)
- [Cilium](https://docs.cilium.io/en/stable/network/servicemesh/ingress/)

All three are tested in Kind and should work in production Kubernetes clusters.

### Gateway API

Gateway API resources are not included in this chart but can be used by pointing an HTTPRoute at the `hubble` service (ports 3000 / 8000).

---

## Testing

All tests run on a local Kind cluster. They provision the full stack -- Kind cluster, ingress controller, ArgoCD v2.10.16, Genesis (from GitHub), and the Orion chart -- then validate the deployment.

### Prerequisites

All tools are provided by the devbox environment:

- `docker`
- `kind`
- `kubectl`
- `helm`
- `make`

### Smoke Tests

Automated tests that provision a cluster, deploy Genesis as a dependency, deploy the Orion chart, verify the login page responds with HTTP 200, then tear down.

Each run is self-contained: create cluster, install, test, destroy.

**Scenario x Provider matrix:**

| Scenario | Description |
|---|---|
| **dns** | Ingress hostname `orion.local` set; tested via `Host` header |
| **nohost** | No ingress host; tested by hitting Kind node IP directly |

**Commands:**

| Test | Command |
|---|---|
| Default (nginx, DNS) | `make smoke-test-dns` |
| Default (nginx, no-host) | `make smoke-test-nohost` |
| Both scenarios (nginx) | `make smoke-test` |
| Traefik, DNS | `make smoke-test-dns-traefik` or `INGRESS_PROVIDER=traefik make smoke-test-dns` |
| Cilium, DNS | `make smoke-test-dns-cilium` or `INGRESS_PROVIDER=cilium make smoke-test-dns` |
| Traefik, no-host | `make smoke-test-nohost-traefik` |
| Cilium, no-host | `make smoke-test-nohost-cilium` |
| **All 6 combinations** | `make smoke-test-all` |

`make smoke-test-all` runs all scenarios and providers sequentially. It fails fast on the first failure and is designed for CI pipelines.

### Interactive Tests

Same provisioning as smoke tests but instead of curling and tearing down, they launch a LinuxServer.io Chromium container on the Kind Docker network with noVNC exposed on `localhost:3000`. Open your browser to `http://localhost:3000` to interact with Orion.

**Commands:**

| Test | Command |
|---|---|
| Default (nginx, DNS) | `make interactive-test-dns` |
| Default (nginx, no-host) | `make interactive-test-nohost` |
| Traefik, DNS | `make interactive-test-dns-traefik` |
| Cilium, no-host | `make interactive-test-nohost-cilium` |

The READY banner shows:
- URL to open in your browser
- The URL loaded inside Chromium (hostname or IP)
- Test IP for direct access

**Cleanup:**
```bash
make interactive-test-clean
```

Stops the browser container and deletes the Kind cluster.

### Test Values

Two values files in `.hack/` drive the test scenarios:

| File | Scenario | host value |
|---|---|---|
| `.hack/test-values-dns.yaml` | DNS | `orion.local` |
| `.hack/test-values-nohost.yaml` | No-host | `""` |

Both files configure basic authentication:

```yaml
hubble:
  env:
    BASIC_AUTH_EMAIL: "admin@juno-innovations.com"
    BASIC_AUTH_PASSWORD: "juno"
```

### How it works

The test scripts (`smoke-test.sh` / `interactive-test.sh`) do the following:

1. Delete any existing Kind cluster
2. Create a fresh Kind cluster
3. Install ArgoCD v2.10.16 (required by Genesis for argoproj.io CRDs)
4. Install Genesis from GitHub tarball (headless, no ingress) as a dependency for Hubble
5. Wait for the genesis pod to be ready
6. Create a `juno-auth-secret` in the argocd namespace
7. Install the selected ingress controller (nginx/traefik/cilium)
8. Deploy the Orion chart with the scenario values file and `ingressClassName` / `ingress.className` set to the provider
9. Wait for the hubble pod to be ready
10. Run a test container (`curlimages/curl` or `lscr.io/linuxserver/chromium`) on the Kind Docker network

**For smoke tests:** The curl container curls `orion-control-plane:80/login` (DNS scenario uses `-H "Host: orion.local"`) and checks for HTTP 200. Retries up to 5 times with 3s delays to allow ingress endpoint sync.

**For interactive tests:** The Chromium container connects to the cluster network. The noVNC web interface is mapped to `localhost:3000`.

After testing, the cluster is torn down (smoke) or left running (interactive).

---

## Usage

For a full deployment guide, see the [setup documentation](https://juno-fx.github.io/Orion-Documentation/genesis5.1.0-orion4.2.0/installation/quick-start/).
