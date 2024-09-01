

.PHONY: talos
talos:
	@ansible-playbook install.yaml -i inventory/hosts.init --user=woobay --ask-become-pass

.PHONY: config
config:
	@ansible-playbook config-cluster.yaml -i inventory/hosts.init
