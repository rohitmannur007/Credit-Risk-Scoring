# r/monitoring_psi.R
# Fixed PSI monitoring (works with new pipeline)

install_if_missing <- function(pkgs){
  new <- pkgs[!(pkgs %in% installed.packages()[,1])]
  if(length(new)) install.packages(new, repos='https://cloud.r-project.org')
}
install_if_missing(c("data.table"))

library(data.table)

cat("=== Running PSI monitoring ===\n")

# ---------- Load predictions ----------
preds <- fread("reports/predictions.csv")

if (!"predicted" %in% names(preds)) {
  stop("Column 'predicted' not found in reports/predictions.csv")
}

scores <- preds$predicted

# ---------- PSI function ----------
psi_calc <- function(ref, cur, bins = 10) {

  cuts <- quantile(ref, probs = seq(0, 1, length.out = bins + 1))
  cuts <- unique(cuts)

  if (length(cuts) <= 1) return(NA_real_)

  ref_tab <- prop.table(table(cut(ref, cuts, include.lowest = TRUE)))
  cur_tab <- prop.table(table(cut(cur, cuts, include.lowest = TRUE)))

  ref_tab[ref_tab == 0] <- 1e-6
  cur_tab[cur_tab == 0] <- 1e-6

  sum((ref_tab - cur_tab) * log(ref_tab / cur_tab))
}

# ---------- Create synthetic cohorts ----------
n <- length(scores)
chunk <- floor(n / 5)

results <- data.table()

ref <- scores[1:chunk]

for (i in 2:5) {

  start <- (i-1)*chunk + 1
  end <- min(i*chunk, n)

  cur <- scores[start:end]

  psi <- psi_calc(ref, cur)

  results <- rbind(results, data.table(
    cohort = paste0("cohort", i),
    psi = psi,
    retrain = psi > 0.15
  ))
}

# ---------- Save results ----------
dir.create("monitoring", showWarnings = FALSE)
fwrite(results, "monitoring/psi_report.csv")

print(results)