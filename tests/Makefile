test :
	Rscript -e "source('testthat.R')" || exit 0

clean :
	echo "Nettoyage des résultats et tests..."
	# Effacement des fichiers du sous-dossier results, sauf README.md
	find results/ -type f -not -name 'README.md' -delete
	echo "✔︎ Nettoyage terminé !"

reset :
	echo "Préparation pour la distribution du dépôt..."
	echo "  • Élimination du cache des données..."
	rm -f ../data/abalone.rds
	rm -f ../data/data_raw/abalone_raw.csv
	echo "  • Remplacement des fichiers de travail par les originaux..."
	Rscript -e "source('tools_tests.R'); read_original('R/import_abalone.R'); read_original('abalone_notebook.qmd')"
	echo "  • Élimination des version compilées des documents Quarto..."
	rm -f ../abalone_notebook.html
	echo "  • Effacement des objets créés pour les tests..."
	find results/ -type f -not -name 'README.md' -delete
	echo "✔︎ Préparation terminée !"

solution :
	echo "Configuration du dépôt avec la solution..."
	echo "  • Vérification du mot de passe..."
	if [ ! -e "results/key" ]; then echo "✗ Exécution interrompue : mot de passe introuvable !" && exit 1; fi
	echo "  • Remplacement des fichiers de travail par les solutions..."
	Rscript -e "source('tools_tests.R'); read_solution('R/import_abalone.R'); read_solution('abalone_notebook.qmd')"
	echo "  • Élimination des version compilées des documents Quarto..."
	rm -f ../abalone_notebook.html
	echo "  • Effacement des objets créés pour les tests..."
	find results/ -type f -not -name 'README.md' -delete
	echo "✔︎ Préparation terminée !"
