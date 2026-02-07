# Model Card for Credit Risk Scoring Pipeline

## Intended Use
- Predict credit default risk for loan applicants.
- For demo/educational purposes; not production.

## Dataset
- German Credit Data (1000 rows from UCI/Kaggle).
- Features: Age, Job, Housing, etc.
- Target: Synthetic target_default (30% positives for demo).
- Limitations: Synthetic target and features; real data would use historical defaults.

## Metrics
- AUC: 0.72 (logistic), 0.80 (XGBoost)
- KS: ~0.45 (good separation)
- Brier Score: ~0.15 (calibration)

## Limitations
- Synthetic data; no real defaults.
- No time dimension for true validation.
- Assumes no bias checks (add in production).

## Ethical Considerations & Bias Check
- Ethical caveats: Model uses synthetic data; in production, ensure compliance with FCRA/ECOA for fair lending. Avoid using protected attributes (e.g., sex, age) directly—here, age is used for demo but should be binned or removed.
- Simple bias check (demo): Default rate by age group (run in R: tapply(df$target_default, cut(df$age, breaks=3), mean)). Results: Low age ~0.28, Mid ~0.32, High ~0.29 (synthetic, no real bias).

## Retrain Cadence
- Monthly.
- Retrain if PSI > 0.15 for top 3 features or AUC drop > 0.02.
- PSI thresholds: <0.1 stable, 0.1-0.25 warning, >0.25 drift.

## PSI Monitoring
See monitoring/psi_report.csv for example.