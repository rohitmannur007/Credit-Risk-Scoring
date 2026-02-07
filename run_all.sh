#!/bin/bash
# run_all.sh - simplified pipeline using python ETL and R scripts

set -e

echo "Running ETL..."
python python/etl.py

echo "Running R baseline..."
Rscript r/credit_baseline.R

echo "Running R explainability..."
Rscript r/explainability.R

echo "Running R PSI monitoring..."
Rscript r/monitoring_psi.R

echo "Pipeline complete. Check reports/ and monitoring/"