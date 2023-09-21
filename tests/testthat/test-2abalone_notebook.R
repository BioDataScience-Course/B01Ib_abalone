# Vérifications de doc/abalone_notebook.qmd

test_that("
  Le bloc-notes est-il compilé un fichier final HTML ?", {
  expect_true(file.exists("../../abalone_notebook.html"))
  expect_true(file.exists("../../abalone_notebook.html") &&
      file.mtime("../../abalone_notebook.html") >=
      file.mtime("../../abalone_notebook.qmd"))

  # Ces tests vérifient la présence du fichier HTML dans une version
  # correspondante à la dernière version du document Quarto source. Vous devez
  # compiler abalone_notebook.qmd après toute modification, et cette
  # compilation doit s'être réalisée sans erreur pour que ce test réussisse
  # (vous devez voir le fichier HTML résultant dans l'onglet Visualisateur à la
  # fin de la compilation).
  # En cas d'erreur, lisez le message qui s'affiche dans l'onglet Travaux et
  # corrigez ce qui ne va pas dans votre document avant de le compiler à
  # nouveau.
  # IL EST TRES IMPORTANT QUE VOTRE DOCUMENT COMPILE ! C'est tout de même le but
  # de votre analyse que d'obtenir le document final HTML.
})
