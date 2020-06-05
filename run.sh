#/bin/bash
port=80
if [ -n "$1" ]; then
    port=$1
fi
docker run -p $port:8888 -v $(pwd)/data:/data -v $(pwd)/app:/app coljac/streamlit_ds:latest &
