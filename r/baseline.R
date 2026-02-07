library(data.table)
library(xgboost)
library(caret)
library(pROC)
library(ggplot2)

set.seed(42)

cat("=== Running OPTIMIZED baseline ===\n")

# Load data
df <- fread("data/customer_agg.csv")

# Detect target
target_col <- names(df)[ncol(df)]
X <- df[, -target_col, with = FALSE]
y <- df[[target_col]]

X_matrix <- as.matrix(X)

# Train/test split
train_idx <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X_matrix[train_idx, ]
X_test  <- X_matrix[-train_idx, ]
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

cat("🔥 Optimized XGBoost AUC:", auc_val, "\n")

fwrite(data.table(actual = y_test, predicted = preds),
       "reports/predictions.csv")

png("reports/roc_curve.png", width = 900, height = 600)
plot(roc_obj,
     main = paste("Optimized ROC Curve (AUC =", round(auc_val, 3), ")"))
dev.off()

cat("Optimized model complete.\n")
