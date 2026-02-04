# Verification_services_Windows

Gestion automatique des services critiques Windows

Ce script PowerShell permet de surveiller et de gérer des services critiques sur une machine Windows. Pour chaque service défini dans la liste, il :

* récupère son état actuel (Running, Stopped, Paused),

* trie les services par statut pour un aperçu clair,

* exporte l’état initial dans un fichier CSV,

* démarre automatiquement les services qui sont arrêtés,

* affiche des messages clairs pour chaque service (démarré ou déjà en fonctionnement),

* actualise l’état final des services et crée un rapport CSV reflétant leur statut après intervention.

Utilisation

1. Modifier la liste $ServicesCritiques pour inclure les services que vous souhaitez surveiller.

2. Adapter les chemins des fichiers CSV $CSVFile et $RapportFile selon vos préférences.

3. Exécuter le script dans PowerShell avec des droits administrateur.

4. Consulter le premier CSV pour l’état initial des services et le second pour le rapport final après redémarrage automatique.
