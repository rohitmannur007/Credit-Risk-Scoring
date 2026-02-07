# Credit-Scoring-Project

## TL;DR Elevator Pitch
Built an end-to-end credit risk scoring pipeline simulating bureau data ingestion, feature engineering, modeling, explainability, monitoring, and business reporting. Used R for modeling (logistic + XGBoost, AUC ~0.75), SQL for aggregation (optional), Python for ETL, Tableau for dashboards, and Excel for simulations. Demonstrates model governance with PSI drift monitoring and what-if analysis.

## Key Results
- Logistic AUC: 0.72 (baseline)
- XGBoost AUC: 0.80 (uplift)
- PSI thresholds: <0.1 stable, >0.15 retrain
- Business impact: Threshold at 0.5 reduces approvals by 20%, defaults by 15% (simulated)

## How to Run
1. conda env create -f environment.yml (or pip install -r requirements.txt for Python-only)
2. conda activate credit-scoring
3. (Optional) ./tests/smoke_test.sh  # Quick ETL test
4. ./run_all.sh  # Full pipeline

Note: By default, ETL does not create a synthetic target_default (CREATE_TARGET=False in python/etl.py). For demo runs with synthetic data (30% default rate), set to True and rerun python/etl.py. If using a real dataset, ensure target_default exists in data/customer_agg.csv.

Outputs: data/customer_agg.csv (aggregated data), reports/predictions.csv (preds), reports/vi_log.png (importance), reports/shap_summary.png (SHAP), monitoring/psi_report.csv (drift), reports/py_packages_freeze.txt & r_session_info.txt (reproducibility).

See MODEL_CARD.md for details. Dataset: German Credit (adapted with synthetic target for demo).