FROM ideonate/streamlit-single:latest
MAINTAINER coljac

RUN pip install plotly h5py matplotlib numpy pandas tensorflow-cpu==2.1
