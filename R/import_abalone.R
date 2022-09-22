# Abalone
# url : https://archive-beta.ics.uci.edu/ml/datasets/abalone
# metadata link : https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.names
# dataset link : https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data

# Packages
SciViews::R("model")
#
# Read dataset -----
dir_create("data/data_raw")
abalone <- read$csv("https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data",
  col_names = c(
    "sex", "length", "diameter", "height", "whole_weight",
    "shucked_weight", "viscera_weight", "shell_weight", "rings"),
  cache_file = "data/data_raw/abalone_raw.csv")

skimr::skim(abalone)

# New variable --------
## Compute the variable `age` (look at the original page to get a clue about the
## relationship between the age and the variable rings)
abalone <- smutate(abalone, age = ___)

# Add labels and units
abalone <- labelise(abalone,
  label = list(___),
  units = list(___))

# Save the dataset
write$rds(abalone, "data/abalone.rds")
