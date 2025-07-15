# loocist23-browserext

**BrowserExt v0.2.6 - by Loocist23**

Outil PowerShell pour récupérer les favoris des principaux navigateurs sur Windows et assister l’export manuel des mots de passe.

## Fonctionnalités

- Copie les favoris des navigateurs Chromium (Chrome, Edge, Brave, Vivaldi, Yandex, Opera, Opera GX) et Firefox.
- Crée un dossier par utilisateur pour organiser les données récupérées.
- Génère un fichier log détaillant les opérations.
- Ouvre automatiquement les pages d’export de mots de passe pour chaque navigateur installé.

## Structure du projet

```
loocist23-browserext/
├── recup.ps1   # Script principal PowerShell
└── run.bat     # Lanceur batch pour exécuter le script PowerShell
```

## Utilisation

1. **Insérez la clé USB** contenant ce dossier sur le PC cible.
2. **Exécutez `run.bat`** (double-cliquez).
3. **Entrez le nom de la personne** (ex: Mme Dupont) quand demandé.
4. Les favoris seront copiés dans `DUMP/<Nom>`.
5. Les pages d’export de mots de passe s’ouvriront automatiquement. **Exportez manuellement les mots de passe** de chaque navigateur (format `.csv`).

## Export manuel des mots de passe

- Ouvrez la page des mots de passe du navigateur.
- Cliquez sur les trois points ⋮ puis sur "Exporter".
- Sauvegardez le fichier `.csv` dans le dossier utilisateur créé.

## Prérequis

- Windows 10/11
- Droits d’accès aux profils utilisateurs
- PowerShell installé

## Sécurité

Aucune donnée sensible (mots de passe) n’est copiée automatiquement. L’export des mots de passe reste manuel pour garantir la confidentialité.

## Auteur

Loocist23
