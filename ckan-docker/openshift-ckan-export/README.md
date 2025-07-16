# CKAN on OpenShift

This directory contains everything you need to deploy CKAN (and its companion services) into an OpenShift project, using YAML manifests exported from an existing cluster, cleaned up, and ready to apply.

---

## 1. Prerequisites

- **OpenShift CLI** (`oc`) installed and logged in  
- An existing OpenShift project/namespace (e.g. `buspark-test-v2-dev`)  
- `yq` (v4.x) installed (if you ever need to tweak or re-clean the manifests)  
- CKAN image (/ckan/Dockerfile.dev) is already built and pushed to Quay:  
  ```bash
  quay.io/buspark_test/spark-ckan:latest
  ```

## 2. Deployment steps

### 1. Select your project

```bash
oc project buspark-test-v2-dev
```

### 2. (Optional) Clean out any old resources

```bash
oc delete all --all
oc delete pvc --all
```

### 3. Apply the cleaned manifests


```bash
cd ckan-docker/openshift-ckan-export
for f in clean-*.yaml; do
  oc apply -f "$f"
done
```

### 4. Verify PVCs bound

```bash
oc get pvc
```

### 5. Wait for all Deployments

```bash
oc rollout status deployment/ckan-dev
oc rollout status deployment/db
oc rollout status deployment/datapusher
oc rollout status deployment/redis
oc rollout status deployment/solr
oc rollout status deployment/nginx
```

### 6. Check pod health & logs

```bash
oc get pods
oc logs -f deployment/ckan-dev
```


### 7. Expose & test the HTTP route

```bash
oc expose svc/nginx --name=ckan-nginx
oc patch route ckan-nginx -p '{"spec":{"to":{"kind":"Service","name":"nginx"},"port":{"targetPort":81}}}'

ROUTE_HOST=$(oc get route ckan-nginx -o jsonpath='{.spec.host}')
curl -I "http://$ROUTE_HOST"
```