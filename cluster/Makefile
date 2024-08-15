.PHONY: argo
argo:
	@helm upgrade argo-cd --install --namespace argo-cd charts/argo-cd/ -f values.yaml

.PHONY: ns
ns:
	@kubectl create ns argo-cd
