# Vérification de R/import_abalone.R

test_that("
  Étape 1 : Importation des données", {

    expect_true(!is.null(read_res("abalone")))
    # Le jeu de données `abalone` est introuvable après l'étape 1.
    # Avez-vous corrigé les erreurs dans le code ?
    # Avez-vous exécuté le code de ce script R ?
    # Avez-vous bien exécuté l'instruction check_object() à la fin ?
  })
