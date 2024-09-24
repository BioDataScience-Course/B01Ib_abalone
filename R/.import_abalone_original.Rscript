# Jeu de données `abalone`
#
# description : https://archive.ics.uci.edu/dataset/1/abalone
# métadonnées : https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.names
# données     : https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data

# Nécessaire pour les tests (exécutez avant toute chose)
if (!"tools:tests" %in% search())
  source(here::here("tests/tools_tests.R"), attach(NULL, name = "tools:tests"))

# Configuration de l'environnement
SciViews::R("model", lang = "fr")


# Étape 1 : importation des données ---------------------------------------

dir_create("data/data_raw")
# Remarque : lorsque vous voyez du code comme "; ROMD5('abalone')" à la fin
# d'une instruction R "normale", il s'agit de code pour sauvegarder des
# résultats intermédiaires qui sont utilisés pour les tests. N'Y TOUCHEZ PAS
# et exécutez la ligne en entier dans R.
abalone <- read$csv(
  "https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data",
  col_names = c(
    "sex", "length", "diameter", "height", "whole_weight",
    "shucked_weight", "viscera_weight", "shell_weight", "rings"),
  cache_file = "data/data_raw/abalone_raw.csv"); ROMD5('abalone')

# Variables quantitatives multipliées par 200 pour établir les valeurs initiales
abalone <- smutate(abalone, across(length:shell_weight, function(x) x * 200))

# Vue d'ensemble des données
skimr::skim(abalone)


# Étape 2 : création d'une nouvelle variable ------------------------------

# Calculez la variable `age` (voyez les pages de description du jeu de données
# pour connaitre la relation entre `ring` et `age`)
abalone <- smutate(abalone, age = ___); ROMD5('abalone', 'abalone2')


# Étape 3 : ajout des labels et des unités --------------------------------

# Inspirez-vous des métadonnées et indiquez les labels et unités pour toutes les
# variables. Utilisez "années" pour l'unité d'âge. Utilisez les abréviations
# standard du SI pour les autres unités (ne convertissez pas les unités, mais
# utilisez le sigle correct). Si une variable n'a pas d'unité, indiquez var = NA
abalone <- labelise(abalone,
  label = list(
    ___
  ),
  units = list(
    ___
  )); RODFS('abalone', 'abalone3')

# Sauvegarder la version finale du jeu de données et nettoyer l'environnement
write$rds(abalone, "data/abalone.rds")
rm(abalone)
