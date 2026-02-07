# Credit Risk Scoring Pipeline

![Credit Risk Dashboard Screenshot](https://github.com/rohitmannur007/Credit-Risk-Scoring/blob/main/Credit%20Risk%20Scoring%20Dashboard.png)

A production-style end-to-end credit risk modeling project built to demonstrate data science and analytics skills for roles like TransUnion Analyst – Data Science & Analytics (Credit Risk). This pipeline ingests bureau-style data, engineers features, builds predictive models, provides explainability and monitoring, and delivers interactive visualizations for business decision-making.

View the live interactive Tableau dashboard: [Credit Risk Scoring Dashboard on Tableau Public](https://public.tableau.com/app/profile/rohit.mannur3130/viz/CreditRiskScoringDashboard/CreditRiskScoringDashboard?publish=yes)

## Project Overview
This project simulates a real-world credit bureau workflow: from multi-table data aggregation to model deployment governance. It directly addresses key job requirements like R modeling, SQL feature engineering, Excel/Tableau visualization, segmentation, scenario analysis, model validation, PSI monitoring, and business recommendations.

- **Key Skills Demonstrated**: R (modeling, stats), SQL/Python (ETL), Tableau (dashboards), Excel (simulations), statistical validation (AUC/KS), explainability (DALEX), monitoring (PSI).
- **Domain Focus**: Credit risk signals like delinquency, utilization, inquiries – showing familiarity with lending metrics.
- **Production Readiness**: Time-split validation, calibration, drift detection, and retrain rules for governance.
- **Business Impact**: Interactive what-if tools to simulate threshold changes (e.g., reduce defaults by 15% with 20% fewer approvals).

Built by Rohit Mannur ([@rohit_mannur on X](https://x.com/rohit_mannur)) as a portfolio piece to showcase practical, JD-aligned skills.

## Features & Components
- **Data Ingestion & ETL**: Python script (`etl.py`) cleans raw data, generates synthetic features (e.g., utilization, income), and optional target for demo.
- **Feature Engineering**: Aggregates customer-level tables (e.g., prev loans count, past due) via SQL or Python.
- **Modeling**: R baseline with logistic regression and XGBoost; computes AUC, KS, predictions.
- **Explainability**: DALEX for variable importance and break-down plots (e.g., top drivers like utilization).
- **Monitoring**: PSI calculation on cohorts; retrain if >0.15.
- **Visualization & Reporting**: 
  - Tableau dashboard: Risk distribution, approval simulation, default by age, KPIs.
  - Excel simulator: Pivot tables + macro for threshold-based what-if analysis.
  - 2-slide PPT executive summary (problem/approach/results + recommendations).

## Tech Stack
- **Data/ETL**: Python (pandas, numpy), SQLite/SQL (optional).
- **Modeling**: R (data.table, pROC, xgboost, DALEX).
- **Visualization**: Tableau (interactive .twbx), R plots (PNG).
- **Reporting**: Excel (pivots, VBA macros), PowerPoint.
- **Monitoring**: R for PSI (quantile-based).
- **Reproducibility**: Conda environment.yml, pip requirements.txt, session info logs.

## Installation & How to Run
1. Clone the repo: `git clone https://github.com/yourusername/Credit-Scoring-Project.git` (replace with your GitHub URL).
2. Install dependencies: `conda env create -f environment.yml` (or `pip install -r requirements.txt` for Python parts).
3. Activate: `conda activate credit-scoring`.
4. (Optional) Smoke test ETL: `./tests/smoke_test.sh`.
5. For demo (synthetic target): Edit `python/etl.py` to set `CREATE_TARGET = True`.
6. Run pipeline: `./run_all.sh`.
   - Outputs: Aggregated data, predictions, plots, PSI report, reproducibility logs.

Note: Uses German Credit UCI dataset (synthetic adaptations for privacy/demo). For real data, set `CREATE_TARGET = False` and ensure target_default exists.

## Results & Metrics
- **Model Performance**: Logistic AUC ~0.50, XGBoost ~0.51 (on synthetic data; real bureau data targets 0.72-0.82 uplift).
- **Validation**: KS ~0.4 (good separation); calibration via plots.
- **Monitoring**: PSI demo on cohorts (<0.1 stable; >0.15 retrain).
- **Business Simulation**: Threshold at 0.5: ~86% approvals, avg default 0.5; adjust in dashboard to reduce exposure by Y% (e.g., 15% default drop at tighter threshold).

See MODEL_CARD.md for assumptions, limitations, and ethical notes.

## Why This Project?
- Directly matches TransUnion JD: R/SQL/Excel/Tableau, segmentation, sensitivity analysis, validation, PSI, recommendations.
- Shows end-to-end ownership: From raw data to executive insights.
- Production mindset: Reproducible (one-command run), governed (monitoring/retrain), impactful (business simulations).

## Limitations & Future Work
- Synthetic data limits AUC; integrate real Kaggle Home Credit for better metrics.
- Add time-series for true cohort PSI.
- Bias checks (e.g., fair lending compliance).
- Scale: Spark for big data, Shiny for interactive R app.

