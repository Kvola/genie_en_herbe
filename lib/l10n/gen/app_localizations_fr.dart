// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get aiCodeLabel => 'Code IA (GH-XXXX-XXXX)';

  @override
  String aiCredits(int count) {
    return 'Crédits IA : $count';
  }

  @override
  String get aiExplain =>
      'Un lot = quelques pages (environ 9 000 caractères). Au-delà du quota gratuit, les crédits IA sont utilisés ; sans crédit, les questions sont tirées du texte sans IA.';

  @override
  String get aiFailures =>
      'L’IA n’a pas réussi plusieurs fois aujourd’hui : questions tirées du texte sans IA.';

  @override
  String aiFreeToday(int left, int daily) {
    return 'Gratuit aujourd’hui : $left lot(s) sur $daily';
  }

  @override
  String get aiLanguage => 'L’IA ne traite pas cette langue.';

  @override
  String get aiOff => 'L’IA n’est pas disponible sur ce serveur.';

  @override
  String get aiQueued =>
      'Questions sans IA prêtes. L’IA prépare de meilleures questions : la fiche se met à jour toute seule.';

  @override
  String get aiQueuedPartly =>
      'L’IA prépare une partie des pages ; quota du jour atteint pour les autres (questions sans IA).';

  @override
  String get aiQuota =>
      'Quota IA du jour atteint : les questions sont tirées du texte sans IA. Un code IA ajoute des crédits.';

  @override
  String get aiRedeem => 'Saisir un code IA';

  @override
  String aiRedeemed(int count) {
    return '$count crédit(s) IA ajouté(s).';
  }

  @override
  String get aiTitle => 'Questions rédigées par l’IA';

  @override
  String get aiUnavailable =>
      'IA indisponible pour l’instant : questions tirées du texte sans IA.';

  @override
  String get appTitle => 'Génie en herbe';

  @override
  String get block => 'Bloquer';

  @override
  String get blockHint =>
      'Ce joueur ne pourra plus vous inviter. Il n’en est pas prévenu.';

  @override
  String blockPlayer(String pseudo) {
    return 'Bloquer $pseudo ?';
  }

  @override
  String get blockedTitle => 'Joueurs bloqués';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get contactFavorite => 'Mettre en favori';

  @override
  String contactMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matchs ensemble',
      one: '1 match ensemble',
      zero: 'aucun match ensemble',
    );
    return '$_temp0';
  }

  @override
  String get contactUnfavorite => 'Retirer des favoris';

  @override
  String get contactsEmpty =>
      'Les joueurs de vos matchs apparaîtront ici. Cherchez un pseudo pour inviter quelqu’un d’autre.';

  @override
  String get contactsHint =>
      'Ceux avec qui vous avez joué, vos favoris, qui peut vous inviter';

  @override
  String get contactsTitle => 'Mes joueurs';

  @override
  String get copied => 'Copié';

  @override
  String get copy => 'Copier';

  @override
  String get createChangePages => 'Changer les pages';

  @override
  String get createChoosePages => 'Choisir les pages';

  @override
  String createHandTime(int seconds) {
    return 'Temps pour répondre après avoir pris la main : $seconds s';
  }

  @override
  String get createHostOnly => 'Organiser sans jouer';

  @override
  String get createHostOnlyHint =>
      'Vous lancez et projetez le match ; d’autres jouent (une classe, deux équipes…).';

  @override
  String get createMatchTitle => 'Nouveau match';

  @override
  String createMaxPlayers(int n) {
    return 'Joueurs au plus : $n';
  }

  @override
  String get createNoPages => 'Aucune page choisie.';

  @override
  String get createNotEnough =>
      'Pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.';

  @override
  String get createPages => 'Pages au programme';

  @override
  String get createPublic => 'Visible dans les matchs ouverts';

  @override
  String get createPublicHint =>
      'Sinon, seuls ceux qui ont le code peuvent entrer.';

  @override
  String createQuestionTime(int seconds) {
    return 'Temps par question : $seconds s';
  }

  @override
  String createQuestions(int n) {
    return 'Questions : $n';
  }

  @override
  String get createSubmit => 'Créer le match';

  @override
  String get createWaitQuestions =>
      'L’IA prépare encore des questions : patientez un peu, ou réduisez le nombre de questions.';

  @override
  String get docAddShared => 'Ajouter un document partagé';

  @override
  String docAdded(String name) {
    return '« $name » ajouté à vos documents.';
  }

  @override
  String docBy(String owner) {
    return 'par $owner';
  }

  @override
  String get docDelete => 'Supprimer le document';

  @override
  String get docDeleteConfirm =>
      'Le document, ses pages et ses questions seront effacés. Les matchs déjà joués gardent leurs questions.';

  @override
  String get docForget => 'Retirer de mes documents';

  @override
  String get docFrom => 'De';

  @override
  String get docImport => 'Charger un document';

  @override
  String get docJustImported =>
      'Document chargé ! Cochez les pages au programme, puis « Préparer les questions » ou « Match ».';

  @override
  String get docMatch => 'Match';

  @override
  String get docNoPublic => 'Aucun document public pour l’instant.';

  @override
  String get docPractice => 'M’entraîner';

  @override
  String get docPrepare => 'Préparer les questions';

  @override
  String get docPrivate => 'Privé';

  @override
  String get docPrivateHint => 'Vous seul le voyez.';

  @override
  String get docPublic => 'Public';

  @override
  String get docPublicHint =>
      'Tous les joueurs le trouvent dans les documents publics. Ses questions restent visibles de vous seul.';

  @override
  String get docPublicLibrary => 'Documents publics';

  @override
  String get docRename => 'Renommer';

  @override
  String get docSearch => 'Rechercher un titre';

  @override
  String get docSelectAll => 'Tout cocher';

  @override
  String get docSelectHint =>
      'Cochez les pages au programme pour préparer leurs questions, créer un match ou un tournoi, ou vous entraîner.';

  @override
  String get docSelectNone => 'Tout décocher';

  @override
  String get docSelectRange => 'Choisir de… à…';

  @override
  String docSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages choisies',
      one: '1 page choisie',
      zero: 'aucune page choisie',
    );
    return '$_temp0';
  }

  @override
  String get docShare => 'Partager';

  @override
  String get docShareCode => 'Code de partage';

  @override
  String get docShareHint =>
      'Dans Génie en herbe : Documents → menu → Ajouter un document partagé, puis saisir ce code.';

  @override
  String docShareText(String name, String code) {
    return 'Je partage le document « $name » sur Génie en herbe. Code : $code';
  }

  @override
  String get docShared => 'Partagé par code';

  @override
  String get docSharedHint =>
      'Ceux qui ont son code peuvent l’ajouter, le lire et jouer dessus.';

  @override
  String get docTo => 'À';

  @override
  String get docTournament => 'Tournoi';

  @override
  String docUnits(int count, String unit) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'slide': 'diapositives',
      'sheet': 'feuilles',
      'part': 'parties',
      'other': 'pages',
    });
    String _temp1 = intl.Intl.selectLogic(unit, {
      'slide': 'diapositive',
      'sheet': 'feuille',
      'part': 'partie',
      'other': 'page',
    });
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $_temp0',
      one: '1 $_temp1',
      zero: 'aucune page',
    );
    return '$_temp2';
  }

  @override
  String get docVisibility => 'Visibilité';

  @override
  String get editorAddOption => 'Ajouter une proposition';

  @override
  String get editorExplain => 'Explication (facultative)';

  @override
  String get editorNeedAnswer =>
      'Cochez une proposition remplie comme bonne réponse.';

  @override
  String get editorNeedOptions => 'Il faut au moins deux propositions.';

  @override
  String editorOption(int n) {
    return 'Proposition $n';
  }

  @override
  String get editorOptionsHint => 'Cochez la bonne réponse.';

  @override
  String get editorPrompt => 'Question';

  @override
  String get editorPromptTooShort => 'La question est trop courte.';

  @override
  String get errBadCode => 'Code incorrect ou expiré.';

  @override
  String get errBanned => 'Votre compte joueur est suspendu.';

  @override
  String get errCorrupt => 'Ce fichier est illisible ou abîmé.';

  @override
  String get errEmptyFile => 'Ce fichier ne contient pas de texte.';

  @override
  String get errEncrypted => 'Ce fichier est protégé par un mot de passe.';

  @override
  String get errFull => 'C’est complet.';

  @override
  String get errHandTaken => 'Trop tard : un autre joueur a pris la main.';

  @override
  String get errHost => 'Vous organisez ce match sans y jouer.';

  @override
  String get errLegacyOffice =>
      'Ancien format Office (.doc, .ppt, .xls) : enregistrez-le en .docx, .pptx, .xlsx ou PDF.';

  @override
  String get errLocked => 'Vous ne pouvez plus répondre à cette question.';

  @override
  String get errNetwork => 'Pas de connexion Internet.';

  @override
  String get errNoHand => 'Vous n’avez plus la main.';

  @override
  String get errNoText =>
      'Aucun texte lisible : un document scanné doit être lu par la reconnaissance de texte (photos de pages, sur Android).';

  @override
  String get errPages => 'Choisissez des pages valables.';

  @override
  String get errQuestions =>
      'Ces pages ne donnent pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.';

  @override
  String get errQuestionsPending =>
      'Les questions de ces pages sont en préparation : réessayez dans une minute.';

  @override
  String get errRateLimited =>
      'Trop de tentatives. Réessayez dans quelques minutes.';

  @override
  String get errScanner =>
      'Le scanner de documents n’est pas disponible sur ce téléphone.';

  @override
  String get errServer =>
      'Le serveur ne répond pas correctement. Réessayez plus tard.';

  @override
  String get errServerBusy =>
      'Trop de parties en cours en ce moment. Réessayez dans quelques minutes.';

  @override
  String get errTooLarge => 'Ce fichier est trop volumineux (40 Mo au plus).';

  @override
  String get errTooLate => 'Le temps est écoulé.';

  @override
  String get errUnknownCode => 'Aucun match ni tournoi avec ce code.';

  @override
  String get errUnsupported => 'Format non pris en charge.';

  @override
  String get eventDuelReady => 'Tournoi : votre duel vous attend !';

  @override
  String eventGroupJoined(String pseudo, String name) {
    return '$pseudo a rejoint le groupe « $name »';
  }

  @override
  String eventInvitation(String captain, String team) {
    return '$captain vous invite dans l’équipe « $team »';
  }

  @override
  String eventRematch(String code) {
    return 'Revanche proposée : code $code';
  }

  @override
  String eventRequest(String pseudo) {
    return '$pseudo demande à entrer dans votre équipe';
  }

  @override
  String get eventSee => 'Voir';

  @override
  String eventTournamentInvitation(String who, String name) {
    return '$who vous invite au tournoi « $name »';
  }

  @override
  String groupBy(String owner) {
    return 'créé par $owner';
  }

  @override
  String get groupCode => 'Code du groupe';

  @override
  String get groupCreate => 'Créer un groupe';

  @override
  String get groupDelete => 'Supprimer le groupe';

  @override
  String get groupDeleteHint => 'Le groupe disparaît pour tous ses membres.';

  @override
  String get groupJoin => 'Rejoindre un groupe';

  @override
  String groupJoined(String name) {
    return 'Vous avez rejoint le groupe « $name ».';
  }

  @override
  String get groupLeave => 'Quitter le groupe';

  @override
  String groupMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
      zero: 'aucun membre',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersTitle => 'Membres';

  @override
  String get groupMine => 'créé par vous';

  @override
  String get groupName => 'Nom du groupe';

  @override
  String get groupNotAGroup => 'Ce code n’est pas celui d’un groupe.';

  @override
  String get groupOwner => 'créateur';

  @override
  String groupRemoveMember(String pseudo) {
    return 'Retirer $pseudo du groupe ?';
  }

  @override
  String get groupRename => 'Renommer le groupe';

  @override
  String get groupRenewCode => 'Nouveau code';

  @override
  String get groupRenewCodeHint =>
      'L’ancien code ne permettra plus d’entrer dans le groupe. Les membres actuels restent.';

  @override
  String get groupShareHint =>
      'Dans Génie en herbe : Jouer → Rejoindre, puis saisir ce code (ou ouvrir le lien).';

  @override
  String groupShareText(String name, String code) {
    return 'Rejoins le groupe « $name » sur Génie en herbe. Code : $code';
  }

  @override
  String groupTransfer(String pseudo) {
    return 'Confier le groupe à $pseudo ?';
  }

  @override
  String get groupTransferAction => 'Confier le groupe';

  @override
  String get groupTransferHint =>
      'Ce joueur deviendra le créateur : lui seul pourra gérer le groupe.';

  @override
  String get groupsHint =>
      'Une classe, un club : invitez tout le groupe d’un geste';

  @override
  String get groupsIntro =>
      'Créez un groupe (une classe, un club), partagez son code : chacun le saisit une fois. Vous pourrez ensuite inviter tout le groupe à un match, ou lui réserver un tournoi.';

  @override
  String get groupsTitle => 'Mes groupes';

  @override
  String get homeScreenBody =>
      'Touchez Partager (le carré avec une flèche), puis « Sur l’écran d’accueil ». L’application s’ouvrira en plein écran et vos données seront mieux conservées.';

  @override
  String get homeScreenDismiss => 'Compris';

  @override
  String get homeScreenTitle => 'Ajoutez l’application à l’écran d’accueil';

  @override
  String get importBlankPage => '(page sans texte)';

  @override
  String importChars(int count) {
    return '$count caractères';
  }

  @override
  String get importDocTitle => 'Titre du document';

  @override
  String get importDuplicate =>
      'Vous aviez déjà chargé ce document : le voici.';

  @override
  String importEmptyPages(int count) {
    return '$count page(s) sans texte (pages blanches, images)';
  }

  @override
  String get importFile => 'Choisir un fichier';

  @override
  String get importFileHint =>
      'PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, texte, HTML, RTF';

  @override
  String get importIntro =>
      'Le texte est lu sur votre téléphone, page par page, puis envoyé au serveur. Le fichier lui-même ne quitte pas le téléphone.';

  @override
  String get importLang => 'Langue du document';

  @override
  String get importLangAuto => 'Reconnue automatiquement';

  @override
  String get importLangHint => 'Les questions sont rédigées dans cette langue.';

  @override
  String importMorePages(int count) {
    return '… et $count autre(s)';
  }

  @override
  String get importNeedTitle => 'Donnez un titre au document.';

  @override
  String get importOther => 'Choisir un autre document';

  @override
  String get importPartsHint =>
      'Ce document n’a pas de pages : il est découpé en parties.';

  @override
  String get importPaste => 'Coller un texte';

  @override
  String get importPasteHint => 'Collez ici le texte du cours…';

  @override
  String get importPasteSub => 'Découpé en parties d’environ 3 000 caractères.';

  @override
  String get importPrivacy =>
      'Les documents sont privés par défaut. Vous pouvez les partager par un code, ou les rendre publics.';

  @override
  String get importReading => 'Lecture du fichier…';

  @override
  String importReadingPages(int done, int total) {
    return 'Lecture des pages : $done / $total';
  }

  @override
  String importRecognizing(int done, int total) {
    return 'Reconnaissance du texte : $done / $total';
  }

  @override
  String get importScan => 'Photographier des pages';

  @override
  String get importScanHint =>
      'Un manuel ou un cahier : une photo par page, le texte est reconnu sur le téléphone.';

  @override
  String get importScanTitle => 'Pages photographiées';

  @override
  String get importSend => 'Envoyer';

  @override
  String get importSending => 'Envoi du document…';

  @override
  String importSendingPages(int done, int total) {
    return 'Envoi : $done / $total pages';
  }

  @override
  String get importTitle => 'Charger un document';

  @override
  String inviteBusy(String names) {
    return 'déjà dans une partie : $names';
  }

  @override
  String get inviteButton => 'Inviter des joueurs';

  @override
  String get inviteDeclined => 'a refusé';

  @override
  String get inviteGroup => 'Inviter le groupe';

  @override
  String get inviteNone => 'Aucune invitation envoyée';

  @override
  String get invitePending => 'invité';

  @override
  String invitePlayersIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs déjà dans la salle',
      one: '1 joueur déjà dans la salle',
      zero: 'personne dans la salle',
    );
    return '$_temp0';
  }

  @override
  String get invitePolicyAll => 'De tout le monde';

  @override
  String get invitePolicyKnown => 'De mes joueurs et de mes groupes seulement';

  @override
  String get invitePolicyNone => 'De personne';

  @override
  String get invitePolicyTitle => 'Recevoir les invitations';

  @override
  String inviteReceived(String who) {
    return '$who vous invite à un match';
  }

  @override
  String inviteSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inviter $count joueurs',
      one: 'Inviter 1 joueur',
      zero: 'Inviter',
    );
    return '$_temp0';
  }

  @override
  String inviteSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs invités',
      one: '1 joueur invité',
      zero: 'Aucun joueur invité',
    );
    return '$_temp0';
  }

  @override
  String inviteSkipAlready(int count) {
    return '$count déjà là ou déjà invité(s)';
  }

  @override
  String inviteSkipGroup(int count) {
    return '$count hors du groupe du tournoi';
  }

  @override
  String get inviteSkipLimit =>
      'limite d’invitations atteinte pour cette heure';

  @override
  String inviteSkipRefused(int count) {
    return '$count n’accepte(nt) pas les invitations';
  }

  @override
  String get libraryEmptyBody =>
      'Chargez un cours ou un manuel avec « Charger un document », ajoutez un document partagé par son code, ou parcourez les documents publics.';

  @override
  String get libraryEmptyTitle => 'Votre bibliothèque est vide';

  @override
  String get libraryMine => 'Mes documents';

  @override
  String get libraryShared => 'Partagés avec moi';

  @override
  String get libraryTitle => 'Mes documents';

  @override
  String get loadError => 'Le contenu n’a pas pu être chargé.';

  @override
  String get lobbyCancelled => 'Ce match a été annulé.';

  @override
  String get lobbyCode => 'Code du match';

  @override
  String get lobbyCreator => 'créateur';

  @override
  String lobbyHostedBy(String pseudo) {
    return 'Organisé par $pseudo, qui ne joue pas';
  }

  @override
  String get lobbyKick => 'Retirer du match';

  @override
  String get lobbyLeave => 'Quitter';

  @override
  String get lobbyLeaveConfirm => 'Quitter ce match ?';

  @override
  String get lobbyLeaveRunning =>
      'Si vous quittez un match en cours, vous l’abandonnez.';

  @override
  String get lobbyNeedPlayers => 'Il faut au moins 2 joueurs.';

  @override
  String get lobbyNoTeam => 'Sans équipe';

  @override
  String get lobbyNoTeamHint =>
      'Les joueurs sans équipe ne jouent pas : demandez à entrer dans une équipe, ou créez-la.';

  @override
  String get lobbyPlayers => 'Joueurs';

  @override
  String get lobbyRevise => 'Réviser les pages';

  @override
  String lobbySettings(int n, int seconds, String hand) {
    return '$n questions · $seconds s par question · main : $hand s';
  }

  @override
  String get lobbyShareHint =>
      'Les autres joueurs saisissent ce code dans Jouer → Rejoindre, ou scannent le QR code avec l’appareil photo.';

  @override
  String lobbyShareText(String passages, String code, String link) {
    return 'Rejoins-moi pour un match de Génie en herbe ($passages) ! Code : $code $link';
  }

  @override
  String get lobbyShareWhatsApp => 'Inviter par WhatsApp';

  @override
  String get lobbyStart => 'Lancer le match';

  @override
  String get lobbyTitle => 'Salle d’attente';

  @override
  String lobbyWaitCreator(String name) {
    return 'En attente du lancement par $name…';
  }

  @override
  String get navDocuments => 'Documents';

  @override
  String get navPlay => 'Jouer';

  @override
  String get navProfile => 'Profil';

  @override
  String get offlineHint =>
      'Vos pages déjà lues restent disponibles ici : relisez-les et entraînez-vous.';

  @override
  String get offlineNoPages =>
      'Aucune page gardée sur cet appareil pour l’instant : ouvrez des pages une fois en ligne.';

  @override
  String get offlineTitle => 'Pas de connexion';

  @override
  String get onlineAccountHint =>
      'Il faut un numéro de téléphone (code reçu par WhatsApp) et un pseudo.';

  @override
  String get onlineBecomePlayer => 'Devenir joueur';

  @override
  String onlineBy(String name) {
    return 'par $name';
  }

  @override
  String get onlineCreateMatch => 'Créer un match';

  @override
  String get onlineCreateTournament => 'Créer un tournoi';

  @override
  String get onlineCurrentMatch => 'Vous avez un match en cours';

  @override
  String onlineCurrentTournament(String name) {
    return 'Vous participez au tournoi « $name »';
  }

  @override
  String get onlineHistory => 'Mes matchs';

  @override
  String get onlineIntro =>
      'Affrontez d’autres joueurs, seul ou en équipe, sur les pages de vos documents. Le premier qui prend la main répond ; une bonne réponse rapporte 10 points, une erreur en coûte 5.';

  @override
  String get onlineInvitations => 'Invitations';

  @override
  String get onlineJoin => 'Rejoindre';

  @override
  String get onlineJoinHint => 'Code à 6 caractères';

  @override
  String get onlineJoinTitle => 'Rejoindre avec un code';

  @override
  String get onlineModeSolo => 'Individuel';

  @override
  String get onlineModeTeam => 'Par équipes';

  @override
  String get onlineMyTournaments => 'Mes tournois';

  @override
  String get onlineNoHistory => 'Vos matchs terminés s’afficheront ici.';

  @override
  String get onlineNoOpenMatch =>
      'Aucun match ouvert pour l’instant. Créez-en un et partagez son code.';

  @override
  String get onlineOpenMatches => 'Matchs ouverts';

  @override
  String get onlineOpenTournaments => 'Tournois ouverts';

  @override
  String get onlineOptional =>
      'Un compte est nécessaire pour charger des documents et jouer.';

  @override
  String onlinePlayers(int players, int max) {
    return '$players/$max joueurs';
  }

  @override
  String get onlineProjection => 'Écran de projection';

  @override
  String get onlineProjectionHint =>
      'Affichez un match en grand (vidéoprojecteur, télévision), sans compte.';

  @override
  String get onlineRealtimeOff =>
      'Connexion lente : l’affichage peut avoir un peu de retard.';

  @override
  String get onlineResume => 'Reprendre';

  @override
  String onlineStats(int played, int won) {
    String _temp0 = intl.Intl.pluralLogic(
      played,
      locale: localeName,
      other: '$played matchs',
      one: '1 match',
      zero: 'Aucun match',
    );
    String _temp1 = intl.Intl.pluralLogic(
      won,
      locale: localeName,
      other: '$won gagnés',
      one: '1 gagné',
      zero: 'aucun gagné',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get onlineTitle => 'Jouer';

  @override
  String get pageAiDone => 'IA ✓';

  @override
  String get pageAiFailed => 'IA indisponible';

  @override
  String get pageAiRunning => 'IA en cours…';

  @override
  String get pageEmpty => 'Page sans texte';

  @override
  String get pageNext => 'Page suivante';

  @override
  String get pageOfflineCopy =>
      'Copie gardée sur cet appareil (pas de réseau).';

  @override
  String get pagePrevious => 'Page précédente';

  @override
  String get pageRead => 'Lire la page';

  @override
  String pageValidated(int count) {
    return '$count validée(s)';
  }

  @override
  String pagesAiPending(int ready, int pages) {
    return '$ready question(s) prête(s) ; l’IA prépare encore $pages page(s)…';
  }

  @override
  String get pagesClear => 'Retirer ces pages';

  @override
  String pagesReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions prêtes',
      one: '1 question prête',
      zero: 'aucune question prête',
    );
    return '$_temp0';
  }

  @override
  String pickerConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Valider $count pages',
      one: 'Valider 1 page',
      zero: 'Valider',
    );
    return '$_temp0';
  }

  @override
  String get pickerHint =>
      'Choisissez un document, puis cochez ses pages. Leurs questions sont préparées aussitôt.';

  @override
  String get pickerTitle => 'Choisir les pages';

  @override
  String playAnswerWas(String answer) {
    return 'Réponse : $answer';
  }

  @override
  String playAnsweredWrong(String name) {
    return '$name s’est trompé : −5';
  }

  @override
  String get playBuzz => 'Je réponds !';

  @override
  String get playCountdown => 'Prêts ?';

  @override
  String get playFromText => 'Tiré du texte';

  @override
  String playHandLost(String name) {
    return '$name a laissé filer la main : −5';
  }

  @override
  String playHandOf(String name) {
    return '$name a la main';
  }

  @override
  String get playLeft => 'a quitté';

  @override
  String get playLocked => 'Vous ne pouvez plus répondre à cette question';

  @override
  String get playLockedTeam =>
      'Votre équipe ne peut plus répondre à cette question';

  @override
  String get playNobody => 'Personne n’a trouvé';

  @override
  String get playPaused => 'Chrono en pause';

  @override
  String playPoints(int points) {
    return '$points pts';
  }

  @override
  String playQuestion(int index, int total) {
    return 'Question $index sur $total';
  }

  @override
  String get playScores => 'Scores';

  @override
  String get playSpectator => 'Vous regardez ce match';

  @override
  String get playTiebreak =>
      'Question décisive : la première bonne réponse l’emporte';

  @override
  String playWonBy(String name) {
    return '$name a trouvé';
  }

  @override
  String get playYourHand => 'À vous ! Choisissez la réponse';

  @override
  String get practiceAgain => 'D’autres questions';

  @override
  String get practiceFalse => 'Faux';

  @override
  String get practiceFinish => 'Voir le résultat';

  @override
  String get practiceLanguage =>
      'L’entraînement sur le téléphone ne sait faire des questions qu’en français et en anglais.';

  @override
  String get practiceNext => 'Question suivante';

  @override
  String get practiceNoPages =>
      'Ces pages ne sont pas disponibles sans réseau : ouvrez-les une fois en ligne.';

  @override
  String get practiceRight => 'Bonne réponse !';

  @override
  String practiceScore(int score, int total) {
    return '$score bonne(s) réponse(s) sur $total';
  }

  @override
  String get practiceThesePages => 'M’entraîner sur ces pages';

  @override
  String get practiceThisPage => 'M’entraîner sur cette page';

  @override
  String get practiceTitle => 'Entraînement';

  @override
  String get practiceTooShort =>
      'Ces pages sont trop courtes pour un entraînement : choisissez-en davantage.';

  @override
  String get practiceTrue => 'Vrai';

  @override
  String get practiceWrong => 'Ce n’est pas ça.';

  @override
  String get profileAccount => 'Compte';

  @override
  String get profileDelete => 'Supprimer mon compte joueur';

  @override
  String get profileDeleteConfirm =>
      'Votre pseudo, votre historique et vos documents seront effacés, et vous quitterez la partie en cours.';

  @override
  String get profileDeleted => 'Compte joueur supprimé';

  @override
  String get profileRename => 'Changer de pseudo';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String get profileTitle => 'Profil';

  @override
  String profileTournamentsWon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournois gagnés',
      one: '1 tournoi gagné',
      zero: 'Aucun tournoi gagné',
    );
    return '$_temp0';
  }

  @override
  String get projectionCodePrompt => 'Code du match à afficher';

  @override
  String get projectionShow => 'Afficher';

  @override
  String projectionWaiting(String code) {
    return 'En attente des joueurs — code $code';
  }

  @override
  String get pseudoHint => '3 à 20 caractères, visible par les autres joueurs';

  @override
  String get pseudoLabel => 'Pseudo';

  @override
  String get pseudoSave => 'C’est parti';

  @override
  String get pseudoTitle => 'Choisissez votre pseudo';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: 'aucune question',
    );
    return '$_temp0';
  }

  @override
  String get questionsPrepared => 'Questions prêtes.';

  @override
  String get report => 'Signaler ce pseudo';

  @override
  String get reportReason => 'Pourquoi ? (facultatif)';

  @override
  String get reportSent => 'Signalement envoyé. Merci.';

  @override
  String get resultAbandon => 'Match arrêté : un camp a quitté la partie.';

  @override
  String get resultBack => 'Retour';

  @override
  String get resultDraw => 'Égalité';

  @override
  String get resultFirst => '1ᵉʳ';

  @override
  String get resultIdle => 'Match clos faute d’activité.';

  @override
  String resultRank(int rank) {
    return '$rankᵉ';
  }

  @override
  String get resultReadPage => 'Relire la page';

  @override
  String get resultRematch => 'Revanche';

  @override
  String get resultRematchSent =>
      'Nouveau match créé : les autres joueurs reçoivent le code.';

  @override
  String get resultReview => 'Revoir les questions';

  @override
  String get resultTiebreak => 'Départagé par une question décisive.';

  @override
  String get resultTiebreakRule =>
      'Égalité parfaite : départagé au règlement (moins d’erreurs, puis rapidité).';

  @override
  String get resultTitle => 'Résultats';

  @override
  String resultWinner(String name) {
    return '$name gagne !';
  }

  @override
  String get resultYouWin => 'Vous avez gagné !';

  @override
  String get retry => 'Réessayer';

  @override
  String get reviewAdd => 'Ajouter une question';

  @override
  String get reviewDelete => 'Supprimer la question';

  @override
  String get reviewEdit => 'Corriger';

  @override
  String get reviewHint =>
      'Les questions validées passent en premier dans les matchs.';

  @override
  String get reviewNone => 'Pas encore de question pour cette page.';

  @override
  String reviewPlayed(int count) {
    return 'posée $count fois';
  }

  @override
  String get reviewProposed => 'À relire';

  @override
  String get reviewRegenerate => 'Régénérer';

  @override
  String get reviewRegenerateAi => 'Régénérer avec l’IA';

  @override
  String get reviewRegenerateHint =>
      'Les questions non validées de cette page sont remplacées par de nouvelles.';

  @override
  String get reviewRegenerateOffline => 'Régénérer sans IA';

  @override
  String get reviewTitle => 'Relire les questions';

  @override
  String get reviewValidateAll => 'Tout valider';

  @override
  String get reviewValidated => 'Validée';

  @override
  String get save => 'Enregistrer';

  @override
  String get scanCameraDenied =>
      'L’accès à la caméra a été refusé. Autorisez-le dans les réglages du téléphone, ou saisissez le code.';

  @override
  String get scanCameraUnavailable =>
      'La caméra n’est pas disponible. Saisissez le code de la partie.';

  @override
  String get scanFromImage => 'Choisir une image';

  @override
  String get scanHint =>
      'Visez le QR code affiché dans la salle d’attente du match ou du tournoi.';

  @override
  String get scanNoQrInImage => 'Aucun QR code de partie dans cette image.';

  @override
  String get scanNotAGame =>
      'Ce QR code n’est pas celui d’une partie de Génie en herbe.';

  @override
  String get scanQr => 'Scanner le QR code';

  @override
  String get scanTorch => 'Lampe';

  @override
  String get scanTypeCode => 'Saisir le code';

  @override
  String get settingsDark => 'Sombre';

  @override
  String get settingsGuide => 'Guide d’utilisation';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLight => 'Clair';

  @override
  String get settingsSystem => 'Comme le téléphone';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get share => 'Partager';

  @override
  String get signInChangeNumber => 'Changer de numéro';

  @override
  String get signInCode => 'Code reçu';

  @override
  String signInCodeSent(String phone) {
    return 'Code envoyé au $phone';
  }

  @override
  String get signInCountry => 'Pays';

  @override
  String get signInPhone => 'Votre numéro de téléphone';

  @override
  String get signInPrivacy =>
      'Votre numéro sert seulement à protéger votre compte. Les autres joueurs ne voient que votre pseudo.';

  @override
  String get signInResend => 'Renvoyer le code';

  @override
  String get signInSendCode => 'Recevoir le code par WhatsApp';

  @override
  String get signInTitle => 'Devenir joueur';

  @override
  String get signInVerify => 'Valider';

  @override
  String get socialTitle => 'Joueurs et groupes';

  @override
  String get sourceAi => 'IA';

  @override
  String get sourceManual => 'Écrite par vous';

  @override
  String get sourceOffline => 'Tirée du texte';

  @override
  String get teamAccept => 'Accepter';

  @override
  String get teamAskJoin => 'Demander à entrer';

  @override
  String get teamCaptain => 'capitaine';

  @override
  String get teamCreate => 'Créer une équipe';

  @override
  String get teamDecline => 'Refuser';

  @override
  String teamInvitation(String captain, String team) {
    return '$captain vous invite dans l’équipe « $team »';
  }

  @override
  String get teamInvite => 'Inviter un joueur';

  @override
  String get teamInviteBusy => 'déjà en partie';

  @override
  String get teamInviteSearch => 'Pseudo du joueur';

  @override
  String get teamInvited => 'invité';

  @override
  String get teamLeave => 'Quitter l’équipe';

  @override
  String get teamName => 'Nom de l’équipe';

  @override
  String get teamRemove => 'Retirer';

  @override
  String get teamRename => 'Renommer';

  @override
  String get teamRequested => 'demande à entrer';

  @override
  String teamSizeHint(int min, int max) {
    return 'De $min à $max joueurs par équipe.';
  }

  @override
  String get textLarger => 'Texte plus grand';

  @override
  String get textSmaller => 'Texte plus petit';

  @override
  String get tourAbandon => 'Abandonner le tournoi';

  @override
  String get tourAbandonBody => 'Votre duel en cours ou à venir sera perdu.';

  @override
  String get tourAbandonTeamBody =>
      'Vous quittez votre équipe ; elle continue sans vous.';

  @override
  String tourAgainst(String name) {
    return 'Contre $name';
  }

  @override
  String get tourBracket => 'Tableau';

  @override
  String get tourBye => 'Exempt';

  @override
  String get tourByeWin => 'Qualifié d’office';

  @override
  String get tourCancel => 'Annuler le tournoi';

  @override
  String get tourCancelBody =>
      'Tous les participants seront prévenus. C’est définitif.';

  @override
  String get tourCancelConfirm => 'Annuler ce tournoi ?';

  @override
  String get tourCancelled => 'Ce tournoi a été annulé.';

  @override
  String get tourCode => 'Code du tournoi';

  @override
  String get tourCreateSubmit => 'Créer le tournoi';

  @override
  String get tourCreateTitle => 'Nouveau tournoi';

  @override
  String get tourDeadlinePassed => 'Délai écoulé, résultat en cours…';

  @override
  String get tourDoubleForfeit => 'Double forfait';

  @override
  String get tourDuelLive => 'En cours';

  @override
  String get tourDuelPending => 'À venir';

  @override
  String get tourDuelPlaying => 'Votre duel est en cours';

  @override
  String get tourDuelReadyWait => 'En attente des joueurs';

  @override
  String get tourEliminated => 'Vous êtes éliminé. Merci d’avoir joué !';

  @override
  String tourEliminatedAt(int round) {
    return 'Vous êtes éliminé au tour $round. Merci d’avoir joué !';
  }

  @override
  String get tourEliminatedTag => 'éliminé';

  @override
  String tourEntriesRange(int min, int max) {
    return 'Participants : de $min à $max';
  }

  @override
  String get tourEntriesTeamHint => 'Une équipe compte pour un participant.';

  @override
  String get tourFinal => 'Finale';

  @override
  String get tourForfeitDelay => 'Délai pour confirmer « Prêt »';

  @override
  String get tourForfeitHint =>
      'Quand un duel s’ouvre, chaque camp a ce délai pour se déclarer prêt. Sinon, il perd par forfait.';

  @override
  String tourForfeitIn(String time) {
    return 'Forfait dans $time';
  }

  @override
  String get tourForfeitResult => 'Forfait';

  @override
  String get tourFormat => 'Formule';

  @override
  String get tourFull => 'Le tournoi est complet.';

  @override
  String get tourGroupField => 'Réservé à un groupe';

  @override
  String get tourGroupFieldHint =>
      'Seuls les membres du groupe pourront s’inscrire.';

  @override
  String get tourGroupNone => 'Ouvert à tous';

  @override
  String tourGroupOnly(String name) {
    return 'Réservé aux membres du groupe « $name »';
  }

  @override
  String tourHoursValue(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n heures',
      one: '1 heure',
      zero: '0 heure',
    );
    return '$_temp0';
  }

  @override
  String get tourJoinDuel => 'Rejoindre le duel';

  @override
  String tourMinutesValue(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
      zero: '0 minute',
    );
    return '$_temp0';
  }

  @override
  String get tourModeSolo => 'Entre joueurs';

  @override
  String get tourModeSoloHint =>
      'Chaque joueur s’inscrit seul ; les duels opposent deux joueurs.';

  @override
  String get tourModeTeam => 'Entre équipes';

  @override
  String get tourModeTeamHint =>
      'Les joueurs forment des équipes ; les duels opposent deux équipes.';

  @override
  String get tourName => 'Nom du tournoi';

  @override
  String get tourNameHint => 'Par ex. : Tournoi des jeunes — Évangile de Jean';

  @override
  String get tourNameTooShort => '3 caractères au moins';

  @override
  String tourNeedEntries(int min, int count) {
    return 'Il faut au moins $min participants pour lancer (inscrits : $count).';
  }

  @override
  String get tourNeedPages => 'Choisissez les pages au programme.';

  @override
  String get tourNoEntries =>
      'Personne n’est encore inscrit. Partagez le code !';

  @override
  String get tourNoWinner => 'Tournoi terminé sans vainqueur.';

  @override
  String tourOpponentReady(String name) {
    return '$name est prêt';
  }

  @override
  String tourOpponentWaiting(String name) {
    return '$name n’a pas encore confirmé';
  }

  @override
  String get tourOrganize => 'Organisation';

  @override
  String tourOrganizedBy(String name) {
    return 'Organisé par $name';
  }

  @override
  String get tourOrganizer => 'Organisateur';

  @override
  String get tourPlay => 'Je joue aussi';

  @override
  String get tourPlaySoloHint =>
      'Vous êtes inscrit d’office. Sinon, vous organisez seulement.';

  @override
  String get tourPlayTeamHint =>
      'Vous créez votre équipe et en êtes le capitaine.';

  @override
  String tourPlayers(int count, int max) {
    return 'Joueurs inscrits : $count/$max';
  }

  @override
  String get tourPublic => 'Visible dans les tournois ouverts';

  @override
  String get tourPublicHint =>
      'Sinon, seuls ceux qui ont le code peuvent s’inscrire.';

  @override
  String get tourQuarterFinals => 'Quarts de finale';

  @override
  String tourQuestionsPerDuel(int n) {
    return 'Questions par duel : $n';
  }

  @override
  String get tourReady => 'Prêt !';

  @override
  String get tourReadyHint =>
      'Le duel commence dès que les deux camps sont prêts.';

  @override
  String get tourRegister => 'M’inscrire';

  @override
  String get tourRegistered =>
      'Vous êtes inscrit. Le tournoi commencera quand l’organisateur le lancera.';

  @override
  String tourRound(int round) {
    return 'Tour $round';
  }

  @override
  String get tourRoundDefault => 'Pages du tournoi';

  @override
  String get tourRoundPages => 'Pages par tour';

  @override
  String get tourRoundPagesHint =>
      'Par défaut, chaque tour porte sur les pages du tournoi. Vous pouvez en choisir d’autres pour un tour (par exemple, la finale sur tout le programme).';

  @override
  String get tourRoundReset => 'Revenir aux pages du tournoi';

  @override
  String get tourRoundStarted => 'Ce tour a commencé';

  @override
  String get tourRules => 'Règlement';

  @override
  String tourRulesDuel(int n, int seconds) {
    return '$n questions par duel · $seconds s par question';
  }

  @override
  String get tourRulesElimination =>
      'Élimination directe : le perdant de chaque duel est éliminé.';

  @override
  String tourRulesEntries(int min, int max) {
    return 'De $min à $max participants';
  }

  @override
  String tourRulesForfeit(int minutes) {
    return '« Prêt » à confirmer dans les $minutes min, sinon forfait';
  }

  @override
  String tourRulesHand(int seconds) {
    return 'Après avoir pris la main : $seconds s pour répondre';
  }

  @override
  String get tourSaved => 'Pages enregistrées';

  @override
  String get tourSemiFinals => 'Demi-finales';

  @override
  String tourShareText(String name, String passages, String code) {
    return 'Inscris-toi au tournoi « $name » de Génie en herbe ($passages) ! Code : $code';
  }

  @override
  String get tourSpectator => 'Vous suivez ce tournoi.';

  @override
  String get tourStart => 'Lancer le tournoi';

  @override
  String get tourStartBody =>
      'Les inscriptions seront closes et le tableau tiré au sort.';

  @override
  String tourStartBodyTeam(int min) {
    return 'Les inscriptions seront closes et le tableau tiré au sort. Les équipes de moins de $min joueurs ne seront pas retenues.';
  }

  @override
  String get tourStartConfirm => 'Lancer le tournoi ?';

  @override
  String get tourStateCancelled => 'Annulé';

  @override
  String get tourStateFinished => 'Terminé';

  @override
  String get tourStateRegistration => 'Inscriptions ouvertes';

  @override
  String get tourStateRunning => 'En cours';

  @override
  String get tourTbd => 'À déterminer';

  @override
  String get tourTeamHint =>
      'Créez votre équipe et invitez vos coéquipiers, ou demandez à entrer dans une équipe ci-dessous.';

  @override
  String tourTeamIncomplete(int min) {
    return 'Équipe incomplète : il faut $min joueurs au moins, sinon elle ne sera pas retenue au lancement.';
  }

  @override
  String get tourTeamReady => 'Votre équipe est prête';

  @override
  String tourTeams(int count, int max) {
    return 'Équipes inscrites : $count/$max';
  }

  @override
  String get tourTitle => 'Tournoi';

  @override
  String get tourUnregister => 'Me désinscrire';

  @override
  String get tourUnregisterConfirm => 'Vous désinscrire de ce tournoi ?';

  @override
  String get tourWaitingNext =>
      'Qualifié ! En attente de votre prochain adversaire.';

  @override
  String tourWinner(String name) {
    return '$name remporte le tournoi !';
  }

  @override
  String get tourYou => 'vous';

  @override
  String get tourYouReady => 'Vous êtes prêt';

  @override
  String get tourYouWon => 'Vous avez gagné le tournoi !';

  @override
  String get tourYourDuel => 'Votre duel';

  @override
  String get unblock => 'Débloquer';

  @override
  String updateAvailable(String version) {
    return 'Version $version disponible';
  }

  @override
  String get updateDownload => 'Télécharger';

  @override
  String get updateLater => 'Plus tard';

  @override
  String updateRequired(String version) {
    return 'Mise à jour obligatoire : version $version';
  }

  @override
  String get updateRequiredHint =>
      'Cette version n’est plus prise en charge : installez la nouvelle pour continuer.';

  @override
  String get webInstallAction => 'Installer';

  @override
  String get webInstallBody =>
      'Plus fluide au quotidien, et vos données ne dépendent plus du navigateur.';

  @override
  String get webInstallTitle => 'Installez l’application Android';

  @override
  String get welcomeSignIn => 'Se connecter';

  @override
  String get welcomeStep1 => 'Chargez un document';

  @override
  String get welcomeStep1Body =>
      'Un cours, un manuel, une présentation ou un tableau : PDF, Word, PowerPoint, Excel, OpenDocument, texte, ou des photos de pages.';

  @override
  String get welcomeStep2 => 'Choisissez les pages';

  @override
  String get welcomeStep2Body =>
      'Les pages au programme : les questions sont préparées pour elles, par l’IA ou tirées du texte.';

  @override
  String get welcomeStep3 => 'Jouez à plusieurs';

  @override
  String get welcomeStep3Body =>
      'Matchs, équipes et tournois : le premier qui prend la main répond. Chaque réponse renvoie à la page.';

  @override
  String get welcomeTagline =>
      'Des concours de questions sur vos cours et vos documents.';
}
