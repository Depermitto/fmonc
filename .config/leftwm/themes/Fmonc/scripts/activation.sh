#!/usr/bin/bash

for script in *; do
	if [[ $script != "activation.sh" ]]; then
		bash $script
	fi
done
