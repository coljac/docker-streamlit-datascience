# Docker Streamlit for data science

Available on Docker hub as `coljac/streamlit_ds:latest`.

This image is based on [ideonate/streamlit-single](https://hub.docker.com/r/ideonate/streamlit-single)/[GitHub](https://github.com/ideonate/streamlit-docker). Installs the following python libraries:

`plotly h5py matplotlib numpy pandas tensorflow-cpu==2.1`

Build like so:

`docker build -t coljac/streamlit_ds:latest .`

Invoke like so:

`docker run -p 8888:8888 -v /path/to/dir/with/script:/app streamlit_ds`

Streamlit will be available on port 8888 on localhost.

## Other stuff

- `data/`, `app/`; a test streamlit application.
- `create_vm.sh`: Assuming azure-cli is installed and running, spins up a (spot) VM and deploys an application using docker, copying the local script and data over.
- `run.sh`: Starts the app running.
