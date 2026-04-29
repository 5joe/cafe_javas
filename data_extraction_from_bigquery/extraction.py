from google.cloud import bigquery

# Create the client
client = bigquery.Client(project="cafe-javas256-493214")

# 1. UPDATE THIS: Replace with your actual dataset and table names
query = """
    SELECT * 
    FROM `dataset_cafe.cafe_sales_cleaned` 
    LIMIT 1000
"""

# Run the query
df = client.query(query).to_dataframe()

# 2. THIS IS THE NEW PART: It saves the data to a file named "my_data.csv"
df.to_csv("my_data.csv", index=False)

print("Data downloaded and saved to my_data.csv")



