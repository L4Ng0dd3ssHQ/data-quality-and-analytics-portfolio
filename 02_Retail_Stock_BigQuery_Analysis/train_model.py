import pandas as pd
from google.cloud import bigquery
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import joblib
import os

# --- Config ---
PROJECT_ID = "my-data-project-488902"
client = bigquery.Client(project=PROJECT_ID)

# --- Load features from BigQuery ---
def load_features():
    query = """
        SELECT
            ticker, date, daily_return, log_return,
            ma_20, ma_50, ma_200,
            momentum_20, momentum_50, momentum_200,
            volatility_30, volume_change, daily_range,
            target
        FROM `my-data-project-488902.market_movers.features`
        ORDER BY ticker, date
    """
    return client.query(query).to_dataframe()

# --- Train model ---
def train(df):
    feature_cols = [
        "daily_return", "log_return",
        "ma_20", "ma_50", "ma_200",
        "momentum_20", "momentum_50", "momentum_200",
        "volatility_30", "daily_range"
    ]

    X = df[feature_cols]
    y = df["target"]

    # 80/20 train/test split, no shuffle (respect time order)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, shuffle=False
    )

    print(f"Training on {len(X_train)} rows, testing on {len(X_test)} rows")

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    # Evaluate
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    print(f"\n✅ Model Accuracy: {accuracy:.2%}")
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred))

    return model, X_test, y_test, y_pred, df

# --- Save predictions back to BigQuery ---
def save_predictions(df, X_test, y_test, y_pred):
    preds_df = X_test.copy()
    preds_df["actual"]    = y_test.values
    preds_df["predicted"] = y_pred

    # Add ticker and date back
    test_idx = y_test.index
    preds_df["ticker"] = df.loc[test_idx, "ticker"].values
    preds_df["date"]   = df.loc[test_idx, "date"].values

    table_id = f"{PROJECT_ID}.market_movers.predictions"
    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
    )
    job = client.load_table_from_dataframe(preds_df, table_id, job_config=job_config)
    job.result()
    print(f"\n✅ Saved {len(preds_df)} predictions to BigQuery")

# --- Save model locally ---
def save_model(model):
    os.makedirs("models", exist_ok=True)
    joblib.dump(model, "models/random_forest.pkl")
    print("✅ Model saved to models/random_forest.pkl")

# --- Run ---
if __name__ == "__main__":
    print("Loading features from BigQuery...")
    df = load_features()

    print("Training model...")
    model, X_test, y_test, y_pred, df = train(df)

    print("\nSaving predictions to BigQuery...")
    save_predictions(df, X_test, y_test, y_pred)

    save_model(model)
    print("\n🎉 Model training complete!")