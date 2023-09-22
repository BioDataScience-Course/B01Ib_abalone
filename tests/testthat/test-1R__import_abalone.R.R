# Vérification de R/import_abalone.R

test_that("Étape 1 : importation des données", {
  expect_true(is_identical_to_ref("abalone1"))
  # Le jeu de données téléchargé `abalone` n'est pas conforme à la référence
  # Assurez-vous que le téléchargement s'est fait correctement.
  # Éventuellement, effacer le fichier data/data_raw/abalone_raw.csv et relancez
  # le script d'importation depuis le début.
})

test_that("Étape 2 : création d'une nouvelle variable", {
  expect_true(is_identical_to_ref("abalone2"))
  # La variable `age` est incorrecte ou le jeu de données a été modifié
  # Vérifiez votre calcul pour la variable `age`
  # Assurez-vous que le jeu de données `abalone` est l'original avec uniquement
  # la colonne `age` en plus.
})

test_that("Étape 3 : ajout des labels et des unités", {
  expect_true(has_labels_all("abalone3"))
  # Les variables de `abalone` n'ont pas toutes des labels
  # Vérifiez votre code à l'intérieur de la fonction `labelise()`.

  expect_true(is_identical_to_ref("abalone3", part = "units"))
  # Les unités des variables de `abalone` sont incorrectes ou manquantes
  # Vérifiez votre code à l'intérieur de la fonction `labelise()` concernant les
  # unités et exercez votre esprit critique pour indiquer ici des unités
  # correctes pour toutes les variables !
})

test_that("Jeu de données final à l'issue de l'importation", {
  expect_true(is_data_df("abalone"))
  # Le jeu de données `abalone` est introuvable.
  # Avez-vous corrigé les erreurs dans le code du script ?
  # Avez-vous exécuté le code de ce script R en entier ?
})
