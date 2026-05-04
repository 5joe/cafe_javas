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



# lets handle the data types in the dataframe
data.info()
data.dtypes


# -- plots for the data --
# -- Pie Chart figure --
filtered_data = data[~data["Item_name"].isin(["ERROR", "UNKNOWN"])]

figure = px.pie(data_frame= data,
                values="Total_Spentq",
                names = "Item_name",
                hole = 0.7,
                color_discrete_sequence=px.colors.qualitative.Vivid)
figure.show()


fig = px.histogram(data, 
                   x="Total_Spentq", 
                   nbins=30,      # Adjusts the number of bars
                   title="Distribution of Transaction Totals",
                   color_discrete_sequence=['#636EFA'], # Standard Plotly Blue
                   template="plotly_white")

fig.update_layout(bargap=0.1) # Adds a small gap between bars for readability
fig.show()



# -- C --
filtered_data = data[~data["Item_name"].isin(["ERROR", "UNKNOWN"])]

final = (filtered_data
         .groupby("Item_name")
         .agg({"Quantityq":"sum"})
         .astype(int)
         .reset_index())

# Plot using the filtered data
fig = px.histogram(final, 
                   x="Item_name", 
                   y = "Quantityq",
                   color_discrete_sequence=['#636EFA'],
                   title="Frequency of Items Sold (Cleaned)",
                   template="plotly_white")

fig.update_xaxes(categoryorder="total descending")
fig.show()




# -- Comparison of the Total Spent for each Item --
filtered_data = data[~data["Item_name"].isin(["ERROR", "UNKNOWN"])]

result = (filtered_data
            .groupby("Item_name")
            .agg({"Total_Spentq": "sum"}) # Column : Function name as string
            .astype(int)
            .reset_index())

# Plot using the filtered data
fig = px.bar(result, 
                   x="Item_name", 
                   y = "Total_Spentq",
                   color_discrete_sequence=['#636EFA'],
                   template="plotly_white")

fig.update_xaxes(categoryorder="total descending")
fig.show()

# -- lets look at the time distribution of these items --
date_handled = (filtered_data)



# 1. Group by date to get daily totals
trend_data = (filtered_data
               .assign(transaction_date = pd.to_datetime(filtered_data["transaction_date"]))
               .groupby(["transaction_date", "Item_name"])["Quantityq"]
               .sum()
               .reset_index())

# 2. Plot the aggregated data
figure1 = px.scatter(trend_data, 
                     x="transaction_date", 
                     y="Quantityq",
                     color ="Item_name",
                     trendline="ols", # This will now show the actual sales growth/decline
                     title="Daily Sales Trend",
                     template="plotly_white")

# Switch to a line for better flow
figure1.update_traces(mode='lines+markers') 
figure1.show()





# more changes
# Create a cleaned version for the time-series plot (removing rows with missing dates)
data_clean = data.dropna(subset=['qtransaction_date']).sort_values('qtransaction_date')

# --- PLOT 1: Revenue Trends Over Time ---
fig_line = px.line(data_clean, 
                  x='qtransaction_date', 
                  y='qTotal_Spent', 
                  title='Daily Revenue Trends',
                  markers=True,
                  labels={'qtransaction_date': 'Date', 'qTotal_Spent': 'Revenue ($)'})
fig_line.show()

# --- PLOT 2: Total Revenue by Item ---
# Aggregating the spent column by Item_name
item_revenue = data.groupby('Item_name')['Total_Spentq'].sum().reset_index()
fig_bar = px.bar(item_revenue, 
                 x='Item_name', 
                 y='Total_Spentq', 
                 color='Item_name',
                 title='Total Revenue per Item',
                 text_auto='.2s')
fig_bar.show()

# --- PLOT 3: Payment Method Distribution (Donut Chart) ---
fig_pie = px.pie(data, 
                 names='Payment_mtd', 
                 values='Total_Spentq', 
                 title='Revenue Split by Payment Method',
                 hole=0.4)
fig_pie.show()

# --- PLOT 4: Location vs Item Performance (Grouped Bar) ---
fig_loc = px.bar(data, 
                 x='Locationq', 
                 y='Total_Spentq', 
                 color='Item_name',
                 title='Sales Performance by Location & Item Type',
                 barmode='group',
                 labels={'qTotal_Spent': 'Total Spent ($)'})
fig_loc.show()