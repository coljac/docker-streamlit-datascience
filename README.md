# Docker Streamlit for data science

Based on [ideonate/streamlit-single](https://hub.docker.com/r/ideonate/streamlit-single)/[GitHub](https://github.com/ideonate/streamlit-docker). Installs the following python libraries:

`plotly h5py matplotlib numpy pandas tensorflow-cpu==2.1`

Build like so:

`docker build -t streamlitds .`

Invoke like so:

`docker run -p 8888:8888 -v /path/to/runnable/script:/app streamlitds`

Streamlit will be available on port 8888 on localhost.
