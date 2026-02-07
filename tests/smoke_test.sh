#!/bin/bash
# tests/smoke_test.sh - Quick smoke test for ETL

python python/etl.py
if [ ! -s data/customer_agg.csv ]; then
  echo "customer_agg.csv missing or empty" && exit 1
fi
echo "Smoke test passed"