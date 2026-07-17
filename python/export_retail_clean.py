import pandas as pd
from sqlalchemy import create_engine

# MySQL connection
username = "root"
password = "YOUR_PASSWORD"  # Replace with your MySQL password
host = "localhost"
database = "online_retail"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}/{database}"
)

# Read the cleaned table
df = pd.read_sql("SELECT * FROM retail_clean", engine)

# Export to CSV
df.to_csv(
    "data/retail_clean_tableau.csv",
    index=False,
    encoding="utf-8"
)

print("CSV exported successfully!")