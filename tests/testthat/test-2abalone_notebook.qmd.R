# Vérifications de abalone_notebook.qmd
aba <- parse_rmd("../../abalone_notebook.qmd",
  allow_incomplete = TRUE, parse_yaml = TRUE)

test_that("Le bloc-notes est-il compilé en un fichier final HTML ?", {
  expect_true(is_rendered("abalone_notebook.qmd"))
  # La version compilée HTML du rapport est introuvable
  # Vous devez créer un rendu de votre bloc-notes Quarto (bouton 'Rendu')
  # Vérifiez aussi que ce rendu se réalise sans erreur, sinon, lisez le message
  # qui s'affiche dans l'onglet 'Travaux' et corrigez ce qui ne va pas dans
  # votre document avant de réaliser à nouveau un rendu HTML.
  # IL EST TRES IMPORTANT QUE VOTRE DOCUMENT COMPILE ! C'est tout de même le but
  # de votre analyse que d'obtenir le document final HTML.

  expect_true(is_rendered_current("abalone_notebook.qmd"))
  # La version compilée HTML du document Quarto existe, mais elle est ancienne
  # Vous avez modifié le document Quarto après avoir réalisé le rendu.
  # La version finale HTML n'est sans doute pas à jour. Recompilez la dernière
  # version de votre bloc-notes en cliquant sur le bouton 'Rendu' et vérifiez
  # que la conversion se fait sans erreur. Sinon, corrigez et regénérez le HTML.
})

test_that("La structure du document est-elle conservée ?", {
  expect_true(all(c("Introduction et but", "Matériel et méthodes",
    "Résultats", "Description des données", "Résumé des variables d'intérêt",
    "Modélisation de la masse totale en fonction de la longueur",
    "Analyse des résidus", "Modélisation de la masse en fonction de l'âge",
    "Analyse des résidus de la seconde régression", "Discussion et conclusion")
    %in% (rmd_node_sections(aba) |> unlist() |> unique())))
  # Les sections (titres) attendues du document ne sont pas toutes présentes
  # Ce test échoue si vous avez modifié la structure du document, un ou
  # plusieurs titres indispensables par rapport aux exercices ont disparu ou ont
  # été modifié. Vérifiez la structure du document par rapport à la version
  # d'origine dans le dépôt "template" du document (lien au début du fichier
  # README.md).

  expect_true(all(c("setup", "import", "correlation1", "correlation1comment",
    "chart1", "chart1comment", "chart2", "chart2comment", "table", "lm1",
    "lm1summary", "lm1comment", "resid1", "resid1comment", "resid2",
    "resid2comment", "resid3", "resid3comment","resid4", "resid4comment",
    "correlation2", "correlation2comment", "lm2", "lm2summary", "lm2comment",
    "resid5", "resid5comment")
    %in% rmd_node_label(aba)))
  # Un ou plusieurs labels de chunks nécessaires à l'évaluation manquent
  # Ce test échoue si vous avez modifié la structure du document, un ou
  # plusieurs chunks indispensables par rapport aux exercices sont introuvables.
  # Vérifiez la structure du document par rapport à la version d'origine dans
  # le dépôt "template" du document (lien au début du fichier README.md).

  expect_true(any(duplicated(rmd_node_label(aba))))
  # Un ou plusieurs labels de chunks sont dupliqués
  # Les labels de chunks doivent absolument être uniques. Vous ne pouvez pas
  # avoir deux chunks qui portent le même label. Vérifiez et modifiez le label
  # dupliqué pour respecter cette règle. Comme les chunks et leurs labels sont
  # imposés dans ce document cadré, cette situation ne devrait pas se produire.
  # Vous avez peut-être involontairement dupliqué une partie du document ?
})

test_that("L'entête YAML a-t-il été complété ?", {
  expect_true(aba[[1]]$author != "___")
  expect_true(!grepl("__", aba[[1]]$author))
  expect_true(grepl("^[^_]....+", aba[[1]]$author))
  # Le nom d'auteur n'est pas complété ou de manière incorrecte dans l'entête
  # Vous devez indiquer votre nom dans l'entête YAML à la place de "___" et
  # éliminer les caractères '_' par la même occasion.

  expect_true(grepl("[a-z]", aba[[1]]$author))
  # Aucune lettre minuscule n'est trouvée dans le nom d'auteur
  # Avez-vous bien complété le champ 'author' dans l'entête YAML ?
  # Vous ne pouvez pas écrire votre nom tout en majuscules. Utilisez une
  # majuscule en début de nom et de prénom, et des minuscules ensuite.

  expect_true(grepl("[A-Z]", aba[[1]]$author))
  # Aucune lettre majuscule n'est trouvée dans le nom d'auteur
  # Avez-vous bien complété le champ 'author' dans l'entête YAML ?
  # Vous ne pouvez pas écrire votre nom tout en minuscules. Utilisez une
  # majuscule en début de nom et de prénom, et des minuscules ensuite.

  expect_true(aba[[1]]$title != "___")
  expect_true(!grepl("__", aba[[1]]$title))
  expect_true(grepl("^[^_]....+", aba[[1]]$title))
  # Le titre n'est pas complété ou de manière incorrecte dans l'entête
  # Vous devez indiquer un titre au document à la place de "___" et
  # éliminer les caractères '_' par la même occasion.

  expect_true(grepl("[a-z]", aba[[1]]$title))
  # Aucune lettre minuscule n'est trouvée dans le titre
  # Avez-vous bien complété le champ 'title' dans l'entête YAML ?
  # Vous ne pouvez pas écrire le titre tout en majuscules. Utilisez une
  # majuscule en début de titre, et des minuscules ensuite.

  expect_true(grepl("[A-Z]", aba[[1]]$title))
  # Aucune lettre majuscule n'est trouvée dans le titre
  # Avez-vous bien complété le champ 'title' dans l'entête YAML ?
  # Vous ne pouvez pas écrire le titre tout en minuscules. Utilisez une
  # majuscule en début de titre, et des minuscules ensuite.
})

test_that("Chunk 'import' : importation des données", {
  expect_true(is_identical_to_ref("import", "names"))
  # Les colonnes dans le tableau `abalone` importé ne sont pas celles attendues
  # Votre jeu de données de départ n'est pas correct. Vérifiez et réexécutez-le
  # script R/import_abalone.R pour corriger le problème.

  expect_true(is_identical_to_ref("import", "classes"))
  # La nature des variables (classe) dans le tableau `abalone` est incorrecte
  # Vérifiez l'importation et la manipulation des données dans le script
  # R/import_abalone.R et réexécutez-le pour corriger le problème.

  expect_true(is_identical_to_ref("import", "nrow"))
  # Le nombre de lignes dans le tableau `abalone` est incorrect
  # Vérifiez l'importation des données dans le script R/import_abalone.R et
  # réexécutez-le pour corriger le problème.

  expect_true(is_identical_to_ref("import", "units"))
  # Les unités renseignées pour les variables de `abalone` sont incorrectes
  # Vérifiez la labélisation des variables dans le script R/import_abalone.R et
  # réexécutez-le pour corriger le problème.

  expect_true(is_identical_to_ref("import", "nas"))
  # Les valeurs manquantes pour les variables de `abalone` sont incorrectes
  # Vérifiez l'importation et la manipulation des données dans le script
  # R/import_abalone.R et réexécutez-le pour corriger le problème.
})

test_that("Chunks 'correlation1' & 'correlation1comment' : corrélations tailles et masses", {
  expect_true(is_identical_to_ref("correlation1"))
  # Le tableau des corrélations n'est pas réalisé ou n'est pas celui attendu
  # Relisez bien la consigne pour déterminer les variables à inclure dans le
  # tableau des corrélations. Utilisez `correlation()` et `tabularise()` pour
  # obtenir un tableau propre.

  expect_true(is_identical_to_ref("correlation1comment"))
  # L'interprétation du tableau des corrélations est (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent le tableau d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'chart1' & 'chart1comment' : graphique masse totale vs longueur", {
  expect_true(is_identical_to_ref("chart1"))
  # Le graphique n'est pas réalisé ou n'est pas celui attendu
  # Relisez les consignes et vérifiez votre code concernant ce graphique.

  expect_true(is_identical_to_ref("chart1comment"))
  # L'interprétation du graphique masse totale vs longueur est (partiellement)
  # fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'chart2' & 'chart2comment' : graphique log(masse totale) vs log(longueur)", {
  expect_true(is_identical_to_ref("chart2"))
  # Le graphique n'est pas réalisé ou n'est pas celui attendu
  # Vérifiez la transformation des données. Les nouvelles variables doivent
  # s'appeler `log_length` et `log_weight` obligatoirement. Vous devez aussi
  # utiliser les labels "log(Longueur de coquille)" et "log(Masse totale)".
  # Vérifiez enfin le code qui génère le graphique.

  expect_true(is_identical_to_ref("chart2comment"))
  # L'interprétation du graphique log(masse totale) vs log(longueur) est
  # (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunk 'table' & interprétation libre : résumé des variables d'intérêt", {
  expect_true(is_identical_to_ref("table"))
  # Les tableaux descriptifs ne sont pas ceux attendus
  # Vérifiez le code du chunk. Seule la description de quelques variables est
  # demandée. Faites en sorte de respecter l'ordre de ces variables par rapport
  # à la consigne.

  expect_true(!(rmd_select(aba, by_section("Résumé des variables d'intérêt")) |>
      as_document() |> grepl("...votre interprétation ici...", x = _,
        fixed = TRUE) |> any()))
  # L'interprétation du tableau de description des données n'est pas faite
  # Remplacez "...votre interprétation ici..." sous le tableau par vos
  # phrases de commentaires libres (à noter que le contenu de vos commentaires
  # n'est pas évalué automatiquement, mais il le sera par vos enseignants).
})

test_that("Chunks 'lm1', 'lm1summary' 'lm1comment', première régression", {
  expect_true(is_identical_to_ref("lm1"))
  # La première régression linéaire réalisée n'est pas celle attendue
  # Vérifiez en particulier la formule que vous avez écrite pour décrire la
  # relation entre les variables dans votre modèle. Relisez les consignes
  # attentivement, si nécessaire. Faut-il réaliser le modèle sur les données
  # transformées ou non ?

  expect_true(is_identical_to_ref("lm1summary"))
  # Le tableau résumé de la première régression linéaire est incorrect
  # Si le modèle est correct(test précédent), vérifiez que vous réalisez bien
  # le résumé de ce modèle et qu'ensuite vous utilisez `tabularise()` pour le
  # mettre en forme.

  expect_true(is_identical_to_ref("lm1comment"))
  # L'interprétation de la première régression  est (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent la régression d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Le code pour l'équation paramétrée du modèle est-il correct ?", {
  expect_true(rmd_select(aba, by_section(
    "Modélisation de la masse totale en fonction de la longueur")) |>
      as_document() |> is_display_param_equation("abalone_lm"))
  # Le code pour générer l'équation paramétrée du premier modèle est incorrect
  # Vous avez appris à faire cela dans un learnr du module. Revoyez cette
  # matière et vérifiez comment l'équation se présente dans le document final
  # généré avec le bouton ('Rendu').
})

test_that("Chunks 'resid1' & 'resid1comment' : graphique d'analyse des résidus #1", {
  expect_true(is_identical_to_ref("resid1"))
  # Le graphique d'analyse des résidus #1 n'est pas réalisé ou est incorrect
  # Relisez les consignes et vérifiez votre code concernant ce graphique.

  expect_true(is_identical_to_ref("resid1comment"))
  # L'interprétation du graphique d'analyse des résidus #1 est (partiellement)
  # fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'resid2' & 'resid2comment' : graphique d'analyse des résidus #2", {
  expect_true(is_identical_to_ref("resid2"))
  # Le graphique d'analyse des résidus #2 n'est pas réalisé ou est incorrect
  # Relisez les consignes et vérifiez votre code concernant ce graphique.

  expect_true(is_identical_to_ref("resid2comment"))
  # L'interprétation du graphique d'analyse des résidus #2 est (partiellement)
  # fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'resid3' & 'resid3comment' : graphique d'analyse des résidus #3", {
  expect_true(is_identical_to_ref("resid3"))
  # Le graphique d'analyse des résidus #3 n'est pas réalisé ou est incorrect
  # Relisez les consignes et vérifiez votre code concernant ce graphique.

  expect_true(is_identical_to_ref("resid3comment"))
  # L'interprétation du graphique d'analyse des résidus #3 est (partiellement)
  # fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'resid4' & 'resid4comment' : graphique d'analyse des résidus #4", {
  expect_true(is_identical_to_ref("resid4"))
  # Le graphique d'analyse des résidus #4 n'est pas réalisé ou est incorrect
  # Relisez les consignes et vérifiez votre code concernant ce graphique.

  expect_true(is_identical_to_ref("resid4comment"))
  # L'interprétation du graphique d'analyse des résidus #4 est (partiellement)
  # fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'correlation2' & 'correlation2comment' : corrélations avec l'âge", {
  expect_true(is_identical_to_ref("correlation2"))
  # Le tableau des corrélations n'est pas réalisé ou n'est pas celui attendu
  # Relisez bien la consigne pour déterminer les variables à inclure dans le
  # tableau des corrélations #2. Utilisez `correlation()` et `tabularise()` pour
  # obtenir un tableau propre.

  expect_true(is_identical_to_ref("correlation2comment"))
  # L'interprétation du tableau des corrélations est (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent le tableau d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'lm2', 'lm2summary' 'lm2comment', seconde régression", {
  expect_true(is_identical_to_ref("lm2"))
  # La seconde régression linéaire réalisée n'est pas celle attendue
  # Vérifiez en particulier la formule que vous avez écrite pour décrire la
  # relation entre les variables dans votre modèle. Relisez les consignes
  # attentivement, si nécessaire.

  expect_true(is_identical_to_ref("lm2summary"))
  # Le tableau résumé de la seconde régression linéaire est incorrect
  # Si le modèle est correct(test précédent), vérifiez que vous réalisez bien
  # le résumé de ce modèle et qu'ensuite vous utilisez `tabularise()` pour le
  # mettre en forme.

  expect_true(is_identical_to_ref("lm2comment"))
  # L'interprétation de la seconde régression  est (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent la régression d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("Chunks 'resid5' & 'resid5comment' : analyse des résidus del a seconde régression", {
  expect_true(is_identical_to_ref("resid5"))
  # Le graphique d'analyse des résidus de la seconde régression linéaire n'est
  # pas réalisé ou est incorrect
  # Relisez les consignes et vérifiez votre code concernant ce graphique. Un
  # graphique bien particulier

  expect_true(is_identical_to_ref("resid5comment"))
  # L'interprétation du graphique d'analyse des résidus de la seconde régression
  # est (partiellement) fausse
  # Vous devez cochez les phrases qui décrivent le graphique d'un 'x' entre les
  # crochets [] -> [x]. Ensuite, vous devez recompiler la version HTML du
  # bloc-notes (bouton 'Rendu') sans erreur pour réactualiser les résultats.
  # Assurez-vous de bien comprendre ce qui est coché ou pas : vous n'aurez plus
  # cette aide plus tard dans le travail de groupe ou les interrogations !
})

test_that("La partie discussion et conclusion est-elle remplie ?", {
  expect_true(!(rmd_select(aba, by_section("Discussion et conclusion")) |>
      as_document() |> grepl("...votre discussion ici...", x = _,
        fixed = TRUE) |> any()))
  # La discussion et les conclusions ne sont pas faites
  # Remplacez "...votre discussion ici..." par vos phrases de commentaires
  # libres (à noter que le contenu de cette section n'est pas évalué
  # automatiquement, mais il le sera par vos enseignants).
})
