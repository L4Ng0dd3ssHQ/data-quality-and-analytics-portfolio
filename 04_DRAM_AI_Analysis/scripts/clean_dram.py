import pandas as pd
# Load Files
df1 = pd.read_csv(r"C:\Users\\01_dram_pricing_comprehensive_2021_2025.csv")
df2 = pd.read_csv(r"C:\Users\\02_dram_tb_enterprise_pricing.csv")

# Remove projected rows 
df1 = df1[~df1["Quarter"].str.contains("Projected")]
df2 = df2[~df2["Quarter"].str.contains("Projected")]

# Fix quarter ranges in df2 - keep first quarter only
df2["Quarter"] = df2["Quarter"].str.split("-").str[0]

# Collapse Market Types into three categories in df2
market_type_mapping = {
    "Retail": "Retail",
    "Retail (Enterprise)": "Retail",
    " Wholesale": "Retail",
    "Contract": "Contract",
    "Spot": "Spot"
}
df2["Market Type"] = df2["Market Type"].replace(market_type_mapping)

# Create new column for price per GB mid point
df1["Price_per_GB_Mid"] = (df1["Price per GB USD (Low)"] + df1["Price per GB USD (High)"]) / 2
df2["Price_per_GB_Mid"] = (df2["Price per GB USD (Low)"] + df2["Price per GB USD (High)"]) / 2

# Create new column for date
df1["Date"] = df1["Year"].astype(str) + "-" + df1["Quarter"]
df2["Date"] = df2["Year"].astype(str) + "-" + df2["Quarter"]

# Save cleaned data to new CSV files
df1.to_csv("01_dram_pricing_cleaned.csv", index=False)
df2.to_csv("02_dram_tb_enterprise_cleaned.csv", index=False)

print("Cleaning complete.")
print(df1.shape)
print(df2.shape)