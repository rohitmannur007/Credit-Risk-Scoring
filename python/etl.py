# python/etl.py
# Realistic synthetic credit risk ETL (no perfect separation)

import pandas as pd
import numpy as np
import os
import sys
import subprocess

RAW = "data/raw/german_credit_data.csv"
OUT = "data/customer_agg.csv"
CREATE_TARGET = True

os.makedirs("data", exist_ok=True)
os.makedirs("reports", exist_ok=True)

# ---------- Load ----------
df = pd.read_csv(RAW, header=0, index_col=0)

df = df.rename(columns=lambda c: c.strip().replace(" ", "_").replace("/", "_").lower())

df["age"] = pd.to_numeric(df["age"], errors="coerce")
df["credit_amount"] = pd.to_numeric(df["credit_amount"], errors="coerce")

df.reset_index(inplace=True)
df.rename(columns={"index": "customer_id"}, inplace=True)

rng = np.random.default_rng(42)

# ---------- Features ----------

df["income"] = rng.normal(55000, 15000, len(df)).clip(20000, 120000)

df["credit_limit"] = df["credit_amount"] + rng.normal(2000, 1000, len(df))
df["credit_limit"] = np.maximum(df["credit_limit"], df["credit_amount"] + 500)

df["utilization"] = df["credit_amount"] / df["credit_limit"]

df["debt_to_income"] = df["credit_amount"] / df["income"]

df["late_payment_score"] = rng.beta(2, 5, len(df))  # skewed realistic

# ---------- Target with noise ----------

if CREATE_TARGET:

    risk_score = (
        2.0 * df["utilization"]
        + 1.5 * df["debt_to_income"]
        + 1.2 * df["late_payment_score"]
        - 0.00002 * df["income"]
        - 0.01 * df["age"]
    )

    # Add heavy noise to avoid perfect separation
    noise = rng.normal(0, 1.5, len(df))

    prob = 1 / (1 + np.exp(-(risk_score + noise)))

    df["target_default"] = rng.binomial(1, prob)

# ---------- Final dataset ----------

cols = [
    "customer_id",
    "age",
    "income",
    "credit_amount",
    "credit_limit",
    "utilization",
    "debt_to_income",
    "late_payment_score",
    "target_default",
]

df[cols].to_csv(OUT, index=False)

print(f"Wrote {OUT} with {len(df)} rows")

# ---------- Repro info ----------

try:
    pip_freeze = subprocess.check_output(
        [sys.executable, "-m", "pip", "freeze"],
        text=True,
    )

    with open("reports/py_packages_freeze.txt", "w") as f:
        f.write(f"Python version: {sys.version}\n\n")
        f.write(pip_freeze)

    print("Saved pip freeze")

except Exception as e:
    print("pip freeze failed:", e)