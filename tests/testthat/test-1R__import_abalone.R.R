# Vérification de R/import_abalone.R

test_that("Importation des données depuis Internet", {

    expect_true(is_dataframe("abalone"))
    # Le jeu de données `abalone` est introuvable après l'étape 1.
    # Avez-vous corrigé les erreurs dans le code ?
    # Avez-vous exécuté le code de ce script R ?
  })
