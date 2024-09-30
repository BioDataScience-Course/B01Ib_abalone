# SDD II module 1 : Morphométrie d'ormeaux

Ce projet nécessite d'avoir assimilé l'ensemble des notions du premier module du cours de Science des Données biologiques 2. Il correspond au dépôt GitHub <https://github.com/BioDataScience-Course/B01Ib_abalone>.

## Objectifs

Ce projet est individuel **court** et **cadré**. Vous devrez :

-   visualiser et décrire des données
-   ajuster et décrire un modèle linéaire simple
-   déterminer l'équation du modèle
-   utiliser l'analyse des résidus pour vérifier si le modèle est pertinent

## Consignes

-   Complétez le fichier `R/import_abalone.R` afin d'obtenir le tableau de données à étudier.

Un tableau comprenant les métadonnées est proposé ci-dessous

| Nom de la variable | Label associé         | Unité  |
|--------------------|-----------------------|--------|
| sex                | Sexe                  | NA     |
| length             | Longueur de coquille  | mm     |
| diameter           | Largeur de coquille   | mm     |
| height             | Épaisseur totale      | mm     |
| whole_weight       | Masse totale          | g      |
| shucked_weight     | Masse des tissus mous | g      |
| viscera_weight     | Masse des viscères    | g      |
| shell_weight       | Masse de la coquille  | g      |
| rings              | Anneaux de croissance | NA     |
| age                | Age                   | années |

-   Complétez les zones manquantes dans le carnet de notes `abalone_notebook.qmd`.

-   Assurez-vous à la fin que vous pouvez compiler une version HTML du fichier `abalone_notebook.qmd` (bouton 'Rendu') sans erreurs. Sinon, corrigez-les avant soumission finale. N'utilisez pas l'argument `echo=FALSE` dans vos chunks. Le code R qui génère les résultats doit rester visible dans la version HTML finale.

-   Utilisez les outils de vérification mis à votre disposition (onglet 'Construire' -\> bouton 'Construire tout').

-   Enfin, vérifiez que votre dernier commit + push est bien enregistré sur GitHub à la fin de l'exercice.
