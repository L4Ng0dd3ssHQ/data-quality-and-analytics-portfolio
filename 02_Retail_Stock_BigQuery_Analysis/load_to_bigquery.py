import pandas as pd
from google.cloud import bigquery
import os

# --- Config ---
PROJECT_ID = "my-data-project-488902"
DATASET    = "market_movers"
client     = bigquery.Client(project=PROJECT_ID)

# --- Tickers and file paths ---
STOCK_TICKERS = ["TGT", "WMT", "ULTA", "KR", "COST"]
INDEX_TICKER  = "SPY"
DATA_DIR      = "data_raw"

# --- Helper: load and clean a single CSV ---
def load_csv(ticker):
    path = os.path.join(DATA_DIR, f"{ticker}.csv")
    df = pd.read_csv(path, encoding="latin1")
    df.columns = [c.strip().lower().replace(" ", "_") for c in df.columns]
    df["ticker"] = ticker
    df["date"] = pd.to_datetime(df["date"], format="%Y-%m-%d", errors="coerce")
    df = df.dropna(subset=["close"])
    return df

# --- Load all stock CSVs ---
def load_prices():
    frames = [load_csv(t) for t in STOCK_TICKERS]
    return pd.concat(frames, ignore_index=True)

# --- Upload a dataframe to BigQuery ---
def upload_to_bq(df, table_name):
    table_id = f"{PROJECT_ID}.{DATASET}.{table_name}"
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",  # overwrite if exists
        autodetect=True,
    )
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()  # wait for it to finish
    print(f"✅ Loaded {len(df)} rows into {table_id}")

# --- Companies metadata ---
def build_companies_df():
    data = [
        ("TGT",  "Target",       "Consumer Defensive", "Discount Stores"),
        ("WMT",  "Walmart",      "Consumer Defensive", "Discount Stores"),
        ("ULTA", "Ulta Beauty",  "Consumer Cyclical",  "Specialty Retail"),
        ("KR",   "Kroger",       "Consumer Defensive", "Grocery Stores"),
        ("COST", "Costco",       "Consumer Defensive", "Discount Stores"),
    ]
    return pd.DataFrame(data, columns=["ticker", "company_name", "sector", "industry"])

# --- Run everything ---
if __name__ == "__main__":
    print("Loading stock prices...")
    prices_df = load_prices()
    upload_to_bq(prices_df, "prices_raw")

    print("Loading index prices (SPY)...")
    spy_df = load_csv(INDEX_TICKER)
    upload_to_bq(spy_df, "index_prices")

    print("Loading company metadata...")
    companies_df = build_companies_df()
    upload_to_bq(companies_df, "companies")

    print("\n🎉 All tables loaded successfully!")