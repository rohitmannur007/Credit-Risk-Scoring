library(data.table)
library(xgboost)
library(pROC)

set.seed(42)

cat("=== Running CLEAN baseline (no leakage) ===\n")

# Load data
df <- fread("data/customer_agg.csv")

# Explicit target name
target_col <- "target_default"

if (!target_col %in% names(df)) {
  stop("target_default column missing!")
}

# Remove target from features
feature_cols <- setdiff(names(df), target_col)

X <- as.matrix(df[, ..feature_cols])
y <- df[[target_col]]

# Train/test split
train_idx <- sample(seq_len(length(y)), size = floor(0.8 * length(y)))

X_train <- X[train_idx, ]
X_test  <- X[-train_idx, ]

y_train <- y[train_idx]
y_test  <- y[-train_idx]

dtrain <- xgb.DMatrix(X_train, label = y_train)
dtest  <- xgb.DMatrix(X_test, label = y_test)

params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  max_depth = 6,
  eta = 0.05,
  subsample = 0.8,
  colsample_bytree = 0.8
)

xgb_model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 300,
  verbose = 0
)

preds <- predict(xgb_model, dtest)

roc_obj <- roc(y_test, preds)
auc_val <- auc(roc_obj)

cat("🔥 Clean XGBoost AUC:", auc_val, "\n")

fwrite(
  data.table(actual = y_test, predicted = preds),
  "reports/predictions.csv"
)

png("reports/roc_curve.png", width = 900, height = 600)
plot(roc_obj,
     main = paste("ROC Curve (AUC =", round(auc_val, 3), ")"))
dev.off()

cat("Baseline complete.\n")