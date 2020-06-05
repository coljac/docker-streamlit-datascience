#/bin/bash
port=8888
if [ -n "$1" ]; then
    port=$1
fi
docker run -p $port:8888 -v $(pwd)/data:/data -v $(pwd)/scripts:/app streamlitds
