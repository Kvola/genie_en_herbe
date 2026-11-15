"""Construit lib/l10n/app_fr.arb et app_en.arb.

Les textes communs au jeu en ligne viennent de Quiz Biblique (même moteur de
jeu) ; ceux de Génie en herbe sont ici. Relancer après modification :
    python3 scripts/gen_arb.py && flutter gen-l10n
Les clés non utilisées par l'application ne sont pas reprises (USED).
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
QUIZ = ROOT.parent / 'biblical_quiz' / 'lib' / 'l10n'

# (fr, en, {placeholder: type})
NEW = {
    'appTitle': ("Génie en herbe", "Génie en herbe", None),
    'onlineTitle': ("Jouer", "Play", None),
    # En français, 0 tombe dans la catégorie « one » : sans =0, « 0 question » s'afficherait « 1 question ».
    'questionsCount': ("{count, plural, =0{aucune question} =1{1 question} other{{count} questions}}",
                       "{count, plural, =0{no questions} =1{1 question} other{{count} questions}}", {'count': 'int'}),
    # Textes repris et adaptés
    'createNotEnough': ("Pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.",
                        "Not enough questions: add pages, or lower the number of questions.", None),
    'lobbyShareText': ("Rejoins-moi pour un match de Génie en herbe ({passages}) ! Code : {code} {link}",
                       "Join me for a Génie en herbe match ({passages})! Code: {code} {link}",
                       {'passages': 'String', 'code': 'String', 'link': 'String'}),
    'onlineIntro': ("Affrontez d’autres joueurs, seul ou en équipe, sur les pages de vos documents. Le premier qui prend la main répond ; une bonne réponse rapporte 10 points, une erreur en coûte 5.",
                    "Take on other players, alone or in a team, on the pages of your documents. The first to grab the hand answers; a right answer earns 10 points, a wrong one costs 5.", None),
    'onlineOptional': ("Un compte est nécessaire pour charger des documents et jouer.",
                       "An account is needed to upload documents and play.", None),
    'profileDeleteConfirm': ("Votre pseudo, votre historique et vos documents seront effacés, et vous quitterez la partie en cours.",
                             "Your nickname, history and documents will be erased, and you will leave the current game.", None),
    'scanNotAGame': ("Ce QR code n’est pas celui d’une partie de Génie en herbe.",
                     "This QR code is not a Génie en herbe game.", None),
    'tourRoundDefault': ("Pages du tournoi", "Tournament pages", None),
    'tourRoundReset': ("Revenir aux pages du tournoi", "Back to the tournament pages", None),
    'tourSaved': ("Pages enregistrées", "Pages saved", None),
    'tourShareText': ("Inscris-toi au tournoi « {name} » de Génie en herbe ({passages}) ! Code : {code}",
                      "Sign up for the “{name}” Génie en herbe tournament ({passages})! Code: {code}",
                      {'name': 'String', 'passages': 'String', 'code': 'String'}),
    'welcomeStep1': ("Chargez un document", "Upload a document", None),
    'welcomeStep2': ("Choisissez les pages", "Choose the pages", None),
    'welcomeStep3': ("Jouez à plusieurs", "Play together", None),
    'welcomeStep1Body': ("Un cours, un manuel, une présentation ou un tableau : PDF, Word, PowerPoint, Excel, OpenDocument, texte, ou des photos de pages.",
                         "A lesson, a textbook, a presentation or a spreadsheet: PDF, Word, PowerPoint, Excel, OpenDocument, text, or photos of pages.", None),
    'welcomeStep2Body': ("Les pages au programme : les questions sont préparées pour elles, par l’IA ou tirées du texte.",
                         "The pages on the syllabus: questions are prepared for them, by AI or drawn from the text.", None),
    'welcomeStep3Body': ("Matchs, équipes et tournois : le premier qui prend la main répond. Chaque réponse renvoie à la page.",
                         "Matches, teams and tournaments: the first to grab the hand answers. Every answer points back to the page.", None),
    'welcomeTagline': ("Des concours de questions sur vos cours et vos documents.",
                       "Quiz competitions on your lessons and documents.", None),
    'welcomeSignIn': ("Se connecter", "Sign in", None),
    # Navigation
    'navDocuments': ("Documents", "Documents", None),
    'navPlay': ("Jouer", "Play", None),
    'navProfile': ("Profil", "Profile", None),
    # Bibliothèque
    'libraryTitle': ("Mes documents", "My documents", None),
    'libraryMine': ("Mes documents", "My documents", None),
    'libraryShared': ("Partagés avec moi", "Shared with me", None),
    'libraryEmptyTitle': ("Votre bibliothèque est vide", "Your library is empty", None),
    'libraryEmptyBody': ("Chargez un cours ou un manuel avec « Charger un document », ajoutez un document partagé par son code, ou parcourez les documents publics.",
                         "Upload a lesson or a textbook with “Upload a document”, add a shared document by its code, or browse public documents.", None),
    'docImport': ("Charger un document", "Upload a document", None),
    'docAddShared': ("Ajouter un document partagé", "Add a shared document", None),
    'docShareCode': ("Code de partage", "Share code", None),
    'docAdded': ("« {name} » ajouté à vos documents.", "“{name}” added to your documents.", {'name': 'String'}),
    'docPublicLibrary': ("Documents publics", "Public documents", None),
    'docSearch': ("Rechercher un titre", "Search a title", None),
    'docNoPublic': ("Aucun document public pour l’instant.", "No public documents yet.", None),
    'docUnits': ("{count, plural, =0{aucune page} =1{1 {unit, select, slide{diapositive} sheet{feuille} part{partie} other{page}}} other{{count} {unit, select, slide{diapositives} sheet{feuilles} part{parties} other{pages}}}}",
                 "{count, plural, =0{no pages} =1{1 {unit, select, slide{slide} sheet{sheet} part{part} other{page}}} other{{count} {unit, select, slide{slides} sheet{sheets} part{parts} other{pages}}}}",
                 {'count': 'int', 'unit': 'String'}),
    'docBy': ("par {owner}", "by {owner}", {'owner': 'String'}),
    'docPrivate': ("Privé", "Private", None),
    'docShared': ("Partagé par code", "Shared by code", None),
    'docPublic': ("Public", "Public", None),
    'docPrivateHint': ("Vous seul le voyez.", "Only you can see it.", None),
    'docSharedHint': ("Ceux qui ont son code peuvent l’ajouter, le lire et jouer dessus.",
                      "People with its code can add it, read it and play on it.", None),
    'docPublicHint': ("Tous les joueurs le trouvent dans les documents publics. Ses questions restent visibles de vous seul.",
                      "All players find it among public documents. Its questions stay visible to you only.", None),
    'docVisibility': ("Visibilité", "Visibility", None),
    'docShare': ("Partager", "Share", None),
    'docShareHint': ("Dans Génie en herbe : Documents → menu → Ajouter un document partagé, puis saisir ce code.",
                     "In Génie en herbe: Documents → menu → Add a shared document, then type this code.", None),
    'docShareText': ("Je partage le document « {name} » sur Génie en herbe. Code : {code}",
                     "I am sharing the document “{name}” on Génie en herbe. Code: {code}", {'name': 'String', 'code': 'String'}),
    'docRename': ("Renommer", "Rename", None),
    'docDelete': ("Supprimer le document", "Delete the document", None),
    'docDeleteConfirm': ("Le document, ses pages et ses questions seront effacés. Les matchs déjà joués gardent leurs questions.",
                         "The document, its pages and its questions will be erased. Matches already played keep their questions.", None),
    'docForget': ("Retirer de mes documents", "Remove from my documents", None),
    'docJustImported': ("Document chargé ! Cochez les pages au programme, puis « Préparer les questions » ou « Match ».",
                        "Document uploaded! Tick the pages on the syllabus, then “Prepare questions” or “Match”.", None),
    'docSelectAll': ("Tout cocher", "Select all", None),
    'docSelectNone': ("Tout décocher", "Clear", None),
    'docSelectRange': ("Choisir de… à…", "Choose from… to…", None),
    'docFrom': ("De", "From", None),
    'docTo': ("À", "To", None),
    'docSelectHint': ("Cochez les pages au programme pour préparer leurs questions, créer un match ou un tournoi, ou vous entraîner.",
                      "Tick the pages on the syllabus to prepare their questions, create a match or a tournament, or practise.", None),
    'docSelected': ("{count, plural, =0{aucune page choisie} =1{1 page choisie} other{{count} pages choisies}}",
                    "{count, plural, =0{no page selected} =1{1 page selected} other{{count} pages selected}}", {'count': 'int'}),
    'docPrepare': ("Préparer les questions", "Prepare questions", None),
    'docMatch': ("Match", "Match", None),
    'docTournament': ("Tournoi", "Tournament", None),
    'docPractice': ("M’entraîner", "Practise", None),
    # Pages et questions
    'pageRead': ("Lire la page", "Read the page", None),
    'pageEmpty': ("Page sans texte", "Page without text", None),
    'pageAiRunning': ("IA en cours…", "AI working…", None),
    'pageAiDone': ("IA ✓", "AI ✓", None),
    'pageAiFailed': ("IA indisponible", "AI unavailable", None),
    'pageValidated': ("{count} validée(s)", "{count} validated", {'count': 'int'}),
    'pagePrevious': ("Page précédente", "Previous page", None),
    'pageNext': ("Page suivante", "Next page", None),
    'pageOfflineCopy': ("Copie gardée sur cet appareil (pas de réseau).", "Copy kept on this device (no network).", None),
    'pagesReady': ("{count, plural, =0{aucune question prête} =1{1 question prête} other{{count} questions prêtes}}",
                   "{count, plural, =0{no question ready} =1{1 question ready} other{{count} questions ready}}", {'count': 'int'}),
    'pagesAiPending': ("{ready} question(s) prête(s) ; l’IA prépare encore {pages} page(s)…",
                       "{ready} question(s) ready; AI is still preparing {pages} page(s)…", {'ready': 'int', 'pages': 'int'}),
    'pagesClear': ("Retirer ces pages", "Remove these pages", None),
    'questionsPrepared': ("Questions prêtes.", "Questions ready.", None),
    'aiQueued': ("Questions sans IA prêtes. L’IA prépare de meilleures questions : la fiche se met à jour toute seule.",
                 "Questions without AI are ready. AI is preparing better questions: this screen updates by itself.", None),
    'aiQueuedPartly': ("L’IA prépare une partie des pages ; quota du jour atteint pour les autres (questions sans IA).",
                       "AI is preparing some of the pages; today’s quota is reached for the others (questions without AI).", None),
    'aiQuota': ("Quota IA du jour atteint : les questions sont tirées du texte sans IA. Un code IA ajoute des crédits.",
                "Today’s AI quota is reached: questions are drawn from the text without AI. An AI code adds credits.", None),
    'aiFailures': ("L’IA n’a pas réussi plusieurs fois aujourd’hui : questions tirées du texte sans IA.",
                   "AI failed several times today: questions are drawn from the text without AI.", None),
    'aiLanguage': ("L’IA ne traite pas cette langue.", "AI does not handle this language.", None),
    'aiUnavailable': ("IA indisponible pour l’instant : questions tirées du texte sans IA.",
                      "AI unavailable for now: questions drawn from the text without AI.", None),
    'aiTitle': ("Questions rédigées par l’IA", "Questions written by AI", None),
    'aiFreeToday': ("Gratuit aujourd’hui : {left} lot(s) sur {daily}", "Free today: {left} batch(es) of {daily}",
                    {'left': 'int', 'daily': 'int'}),
    'aiOff': ("L’IA n’est pas disponible sur ce serveur.", "AI is not available on this server.", None),
    'aiCredits': ("Crédits IA : {count}", "AI credits: {count}", {'count': 'int'}),
    'aiExplain': ("Un lot = quelques pages (environ 9 000 caractères). Au-delà du quota gratuit, les crédits IA sont utilisés ; sans crédit, les questions sont tirées du texte sans IA.",
                  "A batch = a few pages (about 9,000 characters). Beyond the free quota, AI credits are used; without credits, questions are drawn from the text without AI.", None),
    'aiRedeem': ("Saisir un code IA", "Enter an AI code", None),
    'aiCodeLabel': ("Code IA (GH-XXXX-XXXX)", "AI code (GH-XXXX-XXXX)", None),
    'aiRedeemed': ("{count} crédit(s) IA ajouté(s).", "{count} AI credit(s) added.", {'count': 'int'}),
    'sourceAi': ("IA", "AI", None),
    'sourceOffline': ("Tirée du texte", "From the text", None),
    'sourceManual': ("Écrite par vous", "Written by you", None),
    'resultReadPage': ("Relire la page", "Read the page again", None),
    # Relecture
    'reviewTitle': ("Relire les questions", "Review questions", None),
    'reviewHint': ("Les questions validées passent en premier dans les matchs.", "Validated questions come first in matches.", None),
    'reviewNone': ("Pas encore de question pour cette page.", "No question for this page yet.", None),
    'reviewValidated': ("Validée", "Validated", None),
    'reviewProposed': ("À relire", "To review", None),
    'reviewEdit': ("Corriger", "Edit", None),
    'reviewDelete': ("Supprimer la question", "Delete the question", None),
    'reviewAdd': ("Ajouter une question", "Add a question", None),
    'reviewValidateAll': ("Tout valider", "Validate all", None),
    'reviewRegenerate': ("Régénérer", "Regenerate", None),
    'reviewRegenerateAi': ("Régénérer avec l’IA", "Regenerate with AI", None),
    'reviewRegenerateOffline': ("Régénérer sans IA", "Regenerate without AI", None),
    'reviewRegenerateHint': ("Les questions non validées de cette page sont remplacées par de nouvelles.",
                             "This page’s non-validated questions are replaced by new ones.", None),
    'reviewPlayed': ("posée {count} fois", "asked {count} times", {'count': 'int'}),
    'editorPrompt': ("Question", "Question", None),
    'editorOptionsHint': ("Cochez la bonne réponse.", "Tick the right answer.", None),
    'editorOption': ("Proposition {n}", "Choice {n}", {'n': 'int'}),
    'editorAddOption': ("Ajouter une proposition", "Add a choice", None),
    'editorExplain': ("Explication (facultative)", "Explanation (optional)", None),
    'editorPromptTooShort': ("La question est trop courte.", "The question is too short.", None),
    'editorNeedOptions': ("Il faut au moins deux propositions.", "At least two choices are needed.", None),
    'editorNeedAnswer': ("Cochez une proposition remplie comme bonne réponse.", "Tick a filled-in choice as the right answer.", None),
    'save': ("Enregistrer", "Save", None),
    # Import
    'importTitle': ("Charger un document", "Upload a document", None),
    'importIntro': ("Le texte est lu sur votre téléphone, page par page, puis envoyé au serveur. Le fichier lui-même ne quitte pas le téléphone.",
                    "The text is read on your phone, page by page, then sent to the server. The file itself never leaves the phone.", None),
    'importFile': ("Choisir un fichier", "Choose a file", None),
    'importFileHint': ("PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, texte, HTML, RTF", "PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, text, HTML, RTF", None),
    'importScan': ("Photographier des pages", "Photograph pages", None),
    'importScanHint': ("Un manuel ou un cahier : une photo par page, le texte est reconnu sur le téléphone.",
                       "A textbook or a notebook: one photo per page, the text is recognised on the phone.", None),
    'importScanTitle': ("Pages photographiées", "Photographed pages", None),
    'importPaste': ("Coller un texte", "Paste a text", None),
    'importPasteSub': ("Découpé en parties d’environ 3 000 caractères.", "Split into parts of about 3,000 characters.", None),
    'importPasteHint': ("Collez ici le texte du cours…", "Paste the lesson’s text here…", None),
    'importPrivacy': ("Les documents sont privés par défaut. Vous pouvez les partager par un code, ou les rendre publics.",
                      "Documents are private by default. You can share them by a code, or make them public.", None),
    'importReading': ("Lecture du fichier…", "Reading the file…", None),
    'importReadingPages': ("Lecture des pages : {done} / {total}", "Reading pages: {done} / {total}", {'done': 'int', 'total': 'int'}),
    'importRecognizing': ("Reconnaissance du texte : {done} / {total}", "Recognising text: {done} / {total}", {'done': 'int', 'total': 'int'}),
    'importSending': ("Envoi du document…", "Sending the document…", None),
    'importSendingPages': ("Envoi : {done} / {total} pages", "Sending: {done} / {total} pages", {'done': 'int', 'total': 'int'}),
    'importDocTitle': ("Titre du document", "Document title", None),
    'importLang': ("Langue du document", "Document language", None),
    'importLangHint': ("Les questions sont rédigées dans cette langue.", "Questions are written in this language.", None),
    'importLangAuto': ("Reconnue automatiquement", "Detected automatically", None),
    'importChars': ("{count} caractères", "{count} characters", {'count': 'int'}),
    'importEmptyPages': ("{count} page(s) sans texte (pages blanches, images)", "{count} page(s) without text (blank pages, images)", {'count': 'int'}),
    'importPartsHint': ("Ce document n’a pas de pages : il est découpé en parties.", "This document has no pages: it is split into parts.", None),
    'importBlankPage': ("(page sans texte)", "(page without text)", None),
    'importMorePages': ("… et {count} autre(s)", "… and {count} more", {'count': 'int'}),
    'importSend': ("Envoyer", "Send", None),
    'importOther': ("Choisir un autre document", "Choose another document", None),
    'importNeedTitle': ("Donnez un titre au document.", "Give the document a title.", None),
    'importDuplicate': ("Vous aviez déjà chargé ce document : le voici.", "You had already uploaded this document: here it is.", None),
    # Erreurs
    'errLegacyOffice': ("Ancien format Office (.doc, .ppt, .xls) : enregistrez-le en .docx, .pptx, .xlsx ou PDF.",
                        "Old Office format (.doc, .ppt, .xls): save it as .docx, .pptx, .xlsx or PDF.", None),
    'errEmptyFile': ("Ce fichier ne contient pas de texte.", "This file contains no text.", None),
    'errCorrupt': ("Ce fichier est illisible ou abîmé.", "This file is unreadable or damaged.", None),
    'errEncrypted': ("Ce fichier est protégé par un mot de passe.", "This file is password-protected.", None),
    'errTooLarge': ("Ce fichier est trop volumineux (40 Mo au plus).", "This file is too large (40 MB at most).", None),
    'errUnsupported': ("Format non pris en charge.", "Unsupported format.", None),
    'errNoText': ("Aucun texte lisible : un document scanné doit être lu par la reconnaissance de texte (photos de pages, sur Android).",
                  "No readable text: a scanned document must go through text recognition (photos of pages, on Android).", None),
    'errScanner': ("Le scanner de documents n’est pas disponible sur ce téléphone.", "The document scanner is not available on this phone.", None),
    'errQuestions': ("Ces pages ne donnent pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.",
                     "These pages do not give enough questions: add pages, or lower the number of questions.", None),
    'errQuestionsPending': ("Les questions de ces pages sont en préparation : réessayez dans une minute.",
                            "Questions for these pages are being prepared: try again in a minute.", None),
    'errPages': ("Choisissez des pages valables.", "Choose valid pages.", None),
    'errHost': ("Vous organisez ce match sans y jouer.", "You host this match without playing.", None),
    # Création de parties
    'createPages': ("Pages au programme", "Pages on the syllabus", None),
    'createNoPages': ("Aucune page choisie.", "No pages chosen.", None),
    'createChoosePages': ("Choisir les pages", "Choose the pages", None),
    'createChangePages': ("Changer les pages", "Change the pages", None),
    'createWaitQuestions': ("L’IA prépare encore des questions : patientez un peu, ou réduisez le nombre de questions.",
                            "AI is still preparing questions: wait a little, or lower the number of questions.", None),
    'createHostOnly': ("Organiser sans jouer", "Host without playing", None),
    'createHostOnlyHint': ("Vous lancez et projetez le match ; d’autres jouent (une classe, deux équipes…).",
                           "You start and project the match; others play (a class, two teams…).", None),
    'tourNeedPages': ("Choisissez les pages au programme.", "Choose the pages on the syllabus.", None),
    'tourRoundPages': ("Pages par tour", "Pages per round", None),
    'tourRoundPagesHint': ("Par défaut, chaque tour porte sur les pages du tournoi. Vous pouvez en choisir d’autres pour un tour (par exemple, la finale sur tout le programme).",
                           "By default, each round is on the tournament’s pages. You can choose others for a round (for example, the final on the whole syllabus).", None),
    'lobbyHostedBy': ("Organisé par {pseudo}, qui ne joue pas", "Hosted by {pseudo}, who does not play", {'pseudo': 'String'}),
    'lobbyRevise': ("Réviser les pages", "Revise the pages", None),
    'pickerTitle': ("Choisir les pages", "Choose the pages", None),
    'pickerHint': ("Choisissez un document, puis cochez ses pages. Leurs questions sont préparées aussitôt.",
                   "Choose a document, then tick its pages. Their questions are prepared right away.", None),
    'pickerConfirm': ("{count, plural, =0{Valider} =1{Valider 1 page} other{Valider {count} pages}}",
                      "{count, plural, =0{Confirm} =1{Confirm 1 page} other{Confirm {count} pages}}", {'count': 'int'}),
    # Entraînement
    'practiceTitle': ("Entraînement", "Practice", None),
    'practiceThisPage': ("M’entraîner sur cette page", "Practise on this page", None),
    'practiceThesePages': ("M’entraîner sur ces pages", "Practise on these pages", None),
    'practiceTrue': ("Vrai", "True", None),
    'practiceFalse': ("Faux", "False", None),
    'practiceRight': ("Bonne réponse !", "Right!", None),
    'practiceWrong': ("Ce n’est pas ça.", "Not quite.", None),
    'practiceNext': ("Question suivante", "Next question", None),
    'practiceFinish': ("Voir le résultat", "See the result", None),
    'practiceScore': ("{score} bonne(s) réponse(s) sur {total}", "{score} right answer(s) out of {total}", {'score': 'int', 'total': 'int'}),
    'practiceAgain': ("D’autres questions", "More questions", None),
    'practiceLanguage': ("L’entraînement sur le téléphone ne sait faire des questions qu’en français et en anglais.",
                         "Practice on the phone can only make questions in French and English.", None),
    'practiceTooShort': ("Ces pages sont trop courtes pour un entraînement : choisissez-en davantage.",
                         "These pages are too short for practice: choose more.", None),
    'practiceNoPages': ("Ces pages ne sont pas disponibles sans réseau : ouvrez-les une fois en ligne.",
                        "These pages are not available offline: open them once while online.", None),
    'offlineTitle': ("Pas de connexion", "No connection", None),
    'offlineHint': ("Vos pages déjà lues restent disponibles ici : relisez-les et entraînez-vous.",
                    "Pages you have already read stay available here: read them again and practise.", None),
    'offlineNoPages': ("Aucune page gardée sur cet appareil pour l’instant : ouvrez des pages une fois en ligne.",
                       "No pages kept on this device yet: open some pages once while online.", None),
    'textLarger': ("Texte plus grand", "Larger text", None),
    'textSmaller': ("Texte plus petit", "Smaller text", None),
    # Profil et réglages
    'profileTitle': ("Profil", "Profile", None),
    'profileAccount': ("Compte", "Account", None),
    'settingsTitle': ("Réglages", "Settings", None),
    'settingsLanguage': ("Langue", "Language", None),
    'settingsTheme': ("Thème", "Theme", None),
    'settingsSystem': ("Comme le téléphone", "Same as the phone", None),
    'settingsLight': ("Clair", "Light", None),
    'settingsDark': ("Sombre", "Dark", None),
    'settingsGuide': ("Guide d’utilisation", "User guide", None),
    'settingsVersion': ("Version {version}", "Version {version}", {'version': 'String'}),
}


#: Méthodes de chaînes appelées sur une variable nommée `l` (pas des traductions).
NOT_KEYS = {'endsWith', 'isEmpty', 'isNotEmpty', 'length', 'substring', 'text', 'trim', 'toLowerCase', 'split'}


def used_keys():
    keys = set()
    for path in (ROOT / 'lib').rglob('*.dart'):
        if '/l10n/gen/' in str(path):
            continue
        keys.update(re.findall(r'\b(?:l|l10n|c\.l10n|context\.l10n|AppLocalizations\.of\([a-z]+\))\.([a-zA-Z][a-zA-Z0-9_]*)', path.read_text()))
    return keys - NOT_KEYS


def build(lang):
    source = json.loads((QUIZ / ('app_%s.arb' % lang)).read_text())
    template = json.loads((QUIZ / 'app_fr.arb').read_text())
    keys = used_keys()
    out = {'@@locale': lang}
    for k in sorted(keys):
        if k in NEW:
            fr, en, ph = NEW[k]
            out[k] = fr if lang == 'fr' else en
            if lang == 'fr' and ph:
                out['@' + k] = {'placeholders': {name: {'type': t} for name, t in ph.items()}}
        elif k in source:
            out[k] = source[k]
            if lang == 'fr' and ('@' + k) in template:
                out['@' + k] = template['@' + k]
    missing = sorted(k for k in keys if k not in out)
    return out, missing


def main():
    for lang in ('fr', 'en'):
        out, missing = build(lang)
        (ROOT / 'lib' / 'l10n' / ('app_%s.arb' % lang)).write_text(json.dumps(out, ensure_ascii=False, indent=2) + '\n')
        print(lang, len([k for k in out if not k.startswith('@')]), 'clés', ('— MANQUANTES : %s' % missing) if missing else '')
        if missing:
            sys.exit(1)


if __name__ == '__main__':
    main()
