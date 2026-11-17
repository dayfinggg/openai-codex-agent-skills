# Kubernetes manifests and upgrades

Technical reference snapshot dated 2026-11-17. Check the cluster server version, the current Kubernetes release and deprecation docs, and installed CRDs before applying a feature or removal date. Managed clusters may run older minors, so target the server version.

## Workloads

- Declare sidecars as `initContainers` entries with `restartPolicy: Always` (stable since 1.33). They start before the app containers, keep running, stop after them, and do not block Job completion. A second entry under `containers` gives none of that ordering.
- Resize CPU and memory of a running pod in place (stable since 1.35) with `kubectl patch pod <name> --subresource resize --patch '<json>'`, which needs kubectl 1.32+. `resizePolicy[].restartPolicy` defaults to `NotRequired`. Editing a Deployment's pod template still rolls out new pods.
- Give pods behind a Service a 5 to 10 second `lifecycle.preStop.sleep.seconds` (stable since 1.34). EndpointSlice removal runs in parallel with shutdown, so load balancers keep sending traffic for a few seconds. The kubelet runs the sleep, so it works in distroless images where an `exec` hook with `sleep` fails. The sleep counts against `terminationGracePeriodSeconds` (default 30).
- Set `spec.hostUsers: false` to run a pod in a user namespace (stable since 1.36). Nodes need Linux 6.3+ with idmap-capable filesystems and containerd 2.0+ or CRI-O 1.25+.
- Mount data or models straight from a registry with an `image` volume (`volumes[].image.reference`, stable since 1.36) instead of an init container that downloads them.
- ConfigMap and Secret changes reach a running pod only through a whole-volume mount. Values read as environment variables or mounted with `subPath` stay stale until the pod restarts, so roll the workload after changing them.

## Probes

- A liveness probe that checks databases or downstream services restarts healthy pods under load and spreads the outage. Probe only the process itself. Cover slow starts with a `startupProbe` whose `failureThreshold * periodSeconds` exceeds the worst-case startup, and remember that `timeoutSeconds` defaults to 1.
- Exec probes fork a process every period and cost node CPU at high pod density. Prefer `httpGet`, `tcpSocket` or `grpc`.
- gRPC probes reject named ports and connect in plaintext. `grpc.mode: TLS` is alpha in 1.37 behind the `GRPCContainerProbeTLS` feature gate and skips certificate verification.

## Traffic

- Route new HTTP traffic with Gateway API (`gateway.networking.k8s.io/v1`, project release v1.7.0). The Ingress API is frozen. Gateway API types are CRDs, so install them or confirm that the cluster's implementation ships them.
- Ingress NGINX was retired in March 2026 and its repository is archived, so it gets no security fixes. Do not pick it for new clusters, and move existing ones to a Gateway API implementation or another Ingress controller. `ingress2gateway` 1.x converts manifests.
- Read EndpointSlices (`discovery.k8s.io/v1`) in tools and controllers. The core `v1` Endpoints API is deprecated since 1.33.

## Pod Security

- The `restricted` Pod Security Standard rejects pods that omit `seccompProfile.type` (`RuntimeDefault` or `Localhost`), `allowPrivilegeEscalation: false`, `capabilities.drop: ["ALL"]` or `runAsNonRoot: true`. Enforce it with the namespace label `pod-security.kubernetes.io/enforce: restricted` and pin `pod-security.kubernetes.io/enforce-version` to a minor so upgrades do not change the rules.
- Enforce mode checks Pods, not their controllers. A violating Deployment is accepted and its ReplicaSet then fails to create pods. Add the `warn` and `audit` labels too, because those modes also report on workload objects.

## Upgrades and removals

- No built-in API version was removed after 1.32. An apiVersion error such as "no matches for kind" on a current cluster means an old beta that an earlier release stopped serving (such as `extensions/v1beta1`, `policy/v1beta1`, `batch/v1beta1`, `autoscaling/v2beta2` or `flowcontrol.apiserver.k8s.io/v1beta3`) or a CRD that is not installed.
- Since 1.35 the kubelet refuses to start on cgroup v1 nodes unless `failCgroupV1: false` is set. 1.35 is the last minor that supports containerd 1.x, so move nodes to containerd 2.0+ before upgrading past it.
- kube-proxy `ipvs` mode is deprecated since 1.35. It is expected to be off by default by 1.40 and removed by 1.43. Use `nftables`. Check the current mode with `kubectl -n kube-system get configmap kube-proxy -o jsonpath='{.data.config\.conf}' | grep 'mode:'`.
- `gitRepo` volumes are permanently disabled in 1.36. Use an init container or git-sync.
- `Service.spec.externalIPs` is deprecated in 1.36 with removal planned for 1.43. Use a LoadBalancer Service, NodePort or Gateway API.
- kube-dns is deprecated in 1.37 and no packages are expected after 1.40. Use CoreDNS.
- Static pods can no longer reference Secrets or ConfigMaps in 1.37, and the opt-out feature gate is gone.
- On SELinux-enforcing nodes, `SELinuxMount` is on by default in 1.37 for CSI drivers that opt in. Pods with different SELinux labels that share a volume on one node can then fail to start. Set `securityContext.seLinuxChangePolicy: Recursive` on those pods.
