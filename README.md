
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Low cache hits count in CoreDNS
---

This incident type occurs when the cache hits count in a CoreDNS test environment is lower than expected. This could indicate a problem with caching functionality or performance issues. It may require investigation and troubleshooting to determine the root cause of the low cache hits count and resolve the issue.

### Parameters
```shell
# Environment Variables

export NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export COREDNS_CONFIGMAP_NAME="PLACEHOLDER"

export NEW_CACHE_SIZE="PLACEHOLDER"

```

## Debug

### Check if the CoreDNS pods are running
```shell
kubectl get pods -n ${NAMESPACE}
```

### If the pods are not running, check the pod events for any errors
```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

### Check the CoreDNS logs for any errors
```shell
kubectl logs ${POD_NAME} -n ${NAMESPACE}
```

### Check the CoreDNS configuration for any issues
```shell
kubectl get configmap coredns -n ${NAMESPACE}
```

### Check if the Kubernetes DNS service is properly configured with CoreDNS
```shell
kubectl get svc kube-dns  -n ${NAMESPACE}
```

### Check the DNS resolution from a pod
```shell
kubectl run -it --rm check_dns --image=busybox:1.28 --restart=Never -- nslookup ${SERVICE_NAME}.${NAMESPACE}.svc.cluster.local
```

## Repair

### Get the current CoreDNS cache size
```shell
CURRENT_CACHE_SIZE=$(kubectl exec -it $DEPLOYMENT -c $CONTAINER -- cat /etc/coredns/Corefile | grep -oP 'cache\s\{\s*success\s+([\d]+)' | awk '{print $3}')
```

### Increase the CoreDNS cache size by 50%
```shell
NEW_CACHE_SIZE=$(echo "$CURRENT_CACHE_SIZE * 1.5" | bc | awk '{print int($1+0.5)}')
```

### Update the CoreDNS cache size
 with the new cache size
```shell
kubectl patch configmap ${CONFIGMAP_NAME} -n ${NAMESPACE} --type merge --patch '{"data": {"Corefile": "cache ${NEW_CACHE_SIZE} \n"}}'
```

### Restart the CoreDNS pod to apply the changes
```shell
kubectl rollout restart deployment $DEPLOYMENT
```