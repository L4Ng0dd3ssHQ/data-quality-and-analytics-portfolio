import pandas as pd
from google.cloud import bigquery

# --- Config ---
PROJECT_ID = "my-data-project-488902"
client = bigquery.Client(project=PROJECT_ID)

# --- Pull raw prices from BigQuery ---
def load_prices():
    query = """
        SELECT ticker, date, open, high, low, close, volume
        FROM `my-data-project-488902.market_movers.prices_raw`
        ORDER BY ticker, date
    """
    return client.query(query).to_dataframe()

# --- Build features ---
def build_features(df):
    df = df.sort_values(["ticker", "date"]).copy()

    # Returns
    df["daily_return"] = df.groupby("ticker")["close"].pct_change()
    df["log_return"]   = df.groupby("ticker")["close"].transform(
        lambda x: x.div(x.shift(1)).apply(lambda v: __import__("math").log(v) if v > 0 else None)
    )

    # Moving averages
    for window in [20, 50, 200]:
        df[f"ma_{window}"] = df.groupby("ticker")["close"].transform(
            lambda x: x.rolling(window).mean()
        )

    # Momentum
    df["momentum_20"]  = (df["close"] - df["ma_20"])  / df["ma_20"]
    df["momentum_50"]  = (df["close"] - df["ma_50"])  / df["ma_50"]
    df["momentum_200"] = (df["close"] - df["ma_200"]) / df["ma_200"]

    # Volatility (30-day rolling)
    df["volatility_30"] = df.groupby("ticker")["log_return"].transform(
        lambda x: x.rolling(30).std() * (252 ** 0.5)
    )

    # Volume change
    df["volume_change"] = df.groupby("ticker")["volume"].pct_change()

    # Price range
    df["daily_range"] = (df["high"] - df["low"]) / df["close"]

    # Target variable: will price go up tomorrow? (1 = yes, 0 = no)
    df["target"] = (df.groupby("ticker")["close"].shift(-1) > df["close"]).astype(int)

    return df

# --- Upload features to BigQuery ---
def upload_features(df):
    table_id = f"{PROJECT_ID}.market_movers.features"
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
    )
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()
    print(f"✅ Loaded {len(df)} rows into {table_id}")

# --- Run ---
if __name__ == "__main__":
    print("Loading prices from BigQuery...")
    df = load_prices()

    print("Building features...")
    df = build_features(df)

    # Drop rows with nulls (from rolling windows)
    df = df.dropna()
    print(f"Feature dataset shape: {df.shape}")

    print("Uploading features to BigQuery...")
    upload_features(df)
    print("\n🎉 Feature engineering complete!")