# Vérification de R/import_abalone.R

test_that("Importation des données depuis Internet", {

    expect_true(is_data_df("abalone"))
    # Le jeu de données `abalone` est introuvable.
    # Avez-vous corrigé les erreurs dans le code du script ?
    # Avez-vous exécuté le code de ce script R en entièreté ?
  })
