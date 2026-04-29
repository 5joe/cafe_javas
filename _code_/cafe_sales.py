# -- Libraries --
import pandas as pd
import numpy as np
from dash import Dash, html, dcc, dash_table


import plotly.express as px
px.colors.qualitative.swatches()
px.colors.sequential.swatches()
import plotly.graph_objects as go

# -- read the data from the csv --
data = pd.read_csv("../dataset/cleaned_cafe_sales.csv")
data



# further data exploration --
data.info()
data.dtypes

# transaction_date to datetime from object
data["transaction_date"] = pd.to_datetime(data["transaction_date"]) 

# plots and graphs for the final dash





