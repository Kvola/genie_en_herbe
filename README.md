# Génie en herbe

Application mobile (Android, web) : des concours de questions sur les pages de
vos documents. Serveur : module Odoo `genie_en_herbe_backend`.

* **Documents** : PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, texte, ou
  photos de pages (reconnaissance de texte sur le téléphone). Le texte est
  découpé en pages sur le téléphone (`lib/extract/`) et envoyé par lots.
* **Questions** préparées par le serveur (IA ou sans IA), relues par le
  propriétaire du document.
* **Jeu** : matchs, équipes, tournois, organisateur sans jouer, écran de
  projection, QR codes (moteur repris de Quiz Biblique).
* **Révision** : lecture des pages, entraînement seul sur le téléphone
  (`lib/engine/`, repris de Comprendre), pages gardées pour le hors-ligne.

## Développement

```
flutter pub get
python3 scripts/gen_arb.py && flutter gen-l10n   # après modification des textes
flutter test
flutter run --dart-define=GENIE_SERVER=http://10.0.2.2:8096   # serveur local (odoo_dev)
```

Signature : `android/key.properties` (non versionné), clé dans
`~/genie-en-herbe-cles` (voir LISEZ-MOI.txt).
