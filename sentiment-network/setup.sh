#!/bin/bash

# Assume miniconda 3 is installed.
if ! command -v conda &> /dev/null; then
    echo >2 'Missing miniconda 3 installation.'
    exit 1
fi

# Check for dlnd environment.
envs="$(conda env list --json)"
has_dlnd_env=$(
    python - <<EOF
import json
import os

print(any([os.path.basename(env) == 'dlnd'
           for env in json.loads('''$envs''')['envs']]))
EOF
   )

if [[ -n "$has_dlnd_env" ]]; then
    conda install -n dlnd --file requirements.txt --yes
else
    conda create -n dlnd --file requirements.txt --yes
fi

source activate dlnd
pip install git+git://github.com/akaihola/ipython_pytest@master pytest-pylint
