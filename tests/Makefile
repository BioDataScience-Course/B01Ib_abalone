test :
	Rscript -e "source('testthat.R')" || exit 0

clean :
	echo "Nettoyage des résultats et tests..."
	# Effacement des fichiers du sous-dossier results, sauf README.md
	find results/ -type f -not -name 'README.md' -delete
	echo "✔︎ Nettoyage terminé !"

reset :
	echo "TODO: Préparation pour la distribution du dépôt..."
	# Effacement des fichiers du sous-dossier results, sauf README.md
	find results/ -type f -not -name 'README.md' -delete
	# Remplacer les fichiers travaillés par leur version vierge

	sleep 2
	echo "✔︎ Préparation terminée !"

solution :
	echo "TODO: Configuration du dépôt avec la solution..."
	echo "  • Récupération du mot de passe..."
	sleep 2
	# Effacement des fichiers du sous-dossier results, sauf README.md
	find results/ -type f -not -name 'README.md' -delete
	# Remplacer les fichiers de travail par la solution

	echo "✗ Exécution interrompue : mot de passe introuvable !"
