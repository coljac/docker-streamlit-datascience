import streamlit as st
import plotly.express as px
import pandas as pd


@st.cache
def get_data():
    data = pd.read_csv("/data/iris.csv")
    return data

def make_figure(plot_feature):
    data = get_data()
    fig = px.scatter(data,
        x=plot_feature + "_width",
        y=plot_feature + "_length",
        color='species',
        hover_data=['species'],
    )
    return fig

st.title('Everything ought to be working.')

toplot =  st.sidebar.selectbox(
    "Plot:",
    ['sepal', 'petal']
)

    
fig = make_figure(toplot)

st.plotly_chart(fig)






