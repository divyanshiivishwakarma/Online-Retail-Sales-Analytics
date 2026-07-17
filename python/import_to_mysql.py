import pandas as pd
from sqlalchemy import create_engine

# ======= CHANGE THESE =======
username = "root"
password = "YOUR_PASSWORD"  # Replace with your MySQL password
host = "localhost"
database = "online_retail"
# ============================

# Connect to MySQL
engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}/{database}"
)

print("Reading CSV...")

df = pd.read_csv(
    "data/raw/online_retail_2009_2010.csv",
    encoding="ISO-8859-1"
)

print("Rows:", len(df))

print("Uploading to MySQL...")

df.to_sql(
    "retail_2009_2010",
    con=engine,
    if_exists="replace",
    index=False,
    chunksize=5000
)

print("Done!")