#!/bin/bash

podman stop grmot
podman rm grmot
podman build -t grmot:0 .
podman run -i -d --name grmot  --privileged  -p 8888:8888 -v /home/kesmarag/Podman/genre/storage:/storage/ grmot:0 jupyter notebook --ip='0.0.0.0' --port=8888 --no-browser --NotebookApp.token='grmot' --allow-root --notebook-dir=/storage

