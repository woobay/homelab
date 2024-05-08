# Flux Bootstrap on new cluster

1. Export var
```bash
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
```

2. Install Flux on cluster

```bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=homelab \
  --branch=main \
  --path=./cluster \
  --personal
```


