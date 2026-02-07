library(data.table)
library(DALEX)
library(ggplot2)

# Load data
df <- fread("data/customer_agg.csv")

# Auto-detect target column (assume last column is target)
target_col <- names(df)[ncol(df)]

cat("Detected target column:", target_col, "\n")

# Split features + target
X <- df[, -target_col, with = FALSE]
y <- df[[target_col]]

# Train logistic model
formula <- as.formula(paste(target_col, "~ ."))
logistic_model <- glm(formula, data = df, family = binomial)

# Create explainer
explainer_log <- explain(
  logistic_model,
  data = X,
  y = y,
  label = "Logistic"
)

# Global importance
vi <- model_parts(explainer_log)

png("reports/vi_log.png", width = 900, height = 600)
plot(vi)
dev.off()

# Local explanation
local_ex <- predict_parts(
  explainer_log,
  new_observation = X[1],
  type = "break_down"
)

png("reports/shap_summary.png", width = 900, height = 600)
plot(local_ex)
dev.off()

cat("Explainability plots saved to reports/\n")
