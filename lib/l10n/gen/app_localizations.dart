import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @aiCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code IA (GH-XXXX-XXXX)'**
  String get aiCodeLabel;

  /// No description provided for @aiCredits.
  ///
  /// In fr, this message translates to:
  /// **'Crédits IA : {count}'**
  String aiCredits(int count);

  /// No description provided for @aiExplain.
  ///
  /// In fr, this message translates to:
  /// **'Un lot = quelques pages (environ 9 000 caractères). Au-delà du quota gratuit, les crédits IA sont utilisés ; sans crédit, les questions sont tirées du texte sans IA.'**
  String get aiExplain;

  /// No description provided for @aiFailures.
  ///
  /// In fr, this message translates to:
  /// **'L’IA n’a pas réussi plusieurs fois aujourd’hui : questions tirées du texte sans IA.'**
  String get aiFailures;

  /// No description provided for @aiFreeToday.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit aujourd’hui : {left} lot(s) sur {daily}'**
  String aiFreeToday(int left, int daily);

  /// No description provided for @aiLanguage.
  ///
  /// In fr, this message translates to:
  /// **'L’IA ne traite pas cette langue.'**
  String get aiLanguage;

  /// No description provided for @aiOff.
  ///
  /// In fr, this message translates to:
  /// **'L’IA n’est pas disponible sur ce serveur.'**
  String get aiOff;

  /// No description provided for @aiQueued.
  ///
  /// In fr, this message translates to:
  /// **'Questions sans IA prêtes. L’IA prépare de meilleures questions : la fiche se met à jour toute seule.'**
  String get aiQueued;

  /// No description provided for @aiQueuedPartly.
  ///
  /// In fr, this message translates to:
  /// **'L’IA prépare une partie des pages ; quota du jour atteint pour les autres (questions sans IA).'**
  String get aiQueuedPartly;

  /// No description provided for @aiQuota.
  ///
  /// In fr, this message translates to:
  /// **'Quota IA du jour atteint : les questions sont tirées du texte sans IA. Un code IA ajoute des crédits.'**
  String get aiQuota;

  /// No description provided for @aiRedeem.
  ///
  /// In fr, this message translates to:
  /// **'Saisir un code IA'**
  String get aiRedeem;

  /// No description provided for @aiRedeemed.
  ///
  /// In fr, this message translates to:
  /// **'{count} crédit(s) IA ajouté(s).'**
  String aiRedeemed(int count);

  /// No description provided for @aiTitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions rédigées par l’IA'**
  String get aiTitle;

  /// No description provided for @aiUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'IA indisponible pour l’instant : questions tirées du texte sans IA.'**
  String get aiUnavailable;

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Génie en herbe'**
  String get appTitle;

  /// No description provided for @block.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer'**
  String get block;

  /// No description provided for @blockHint.
  ///
  /// In fr, this message translates to:
  /// **'Ce joueur ne pourra plus vous inviter. Il n’en est pas prévenu.'**
  String get blockHint;

  /// No description provided for @blockPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer {pseudo} ?'**
  String blockPlayer(String pseudo);

  /// No description provided for @blockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs bloqués'**
  String get blockedTitle;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @contactFavorite.
  ///
  /// In fr, this message translates to:
  /// **'Mettre en favori'**
  String get contactFavorite;

  /// No description provided for @contactMatches.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucun match ensemble} =1{1 match ensemble} other{{count} matchs ensemble}}'**
  String contactMatches(int count);

  /// No description provided for @contactUnfavorite.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get contactUnfavorite;

  /// No description provided for @contactsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Les joueurs de vos matchs apparaîtront ici. Cherchez un pseudo pour inviter quelqu’un d’autre.'**
  String get contactsEmpty;

  /// No description provided for @contactsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ceux avec qui vous avez joué, vos favoris, qui peut vous inviter'**
  String get contactsHint;

  /// No description provided for @contactsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes joueurs'**
  String get contactsTitle;

  /// No description provided for @copied.
  ///
  /// In fr, this message translates to:
  /// **'Copié'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @createChangePages.
  ///
  /// In fr, this message translates to:
  /// **'Changer les pages'**
  String get createChangePages;

  /// No description provided for @createChoosePages.
  ///
  /// In fr, this message translates to:
  /// **'Choisir les pages'**
  String get createChoosePages;

  /// No description provided for @createHandTime.
  ///
  /// In fr, this message translates to:
  /// **'Temps pour répondre après avoir pris la main : {seconds} s'**
  String createHandTime(int seconds);

  /// No description provided for @createHostOnly.
  ///
  /// In fr, this message translates to:
  /// **'Organiser sans jouer'**
  String get createHostOnly;

  /// No description provided for @createHostOnlyHint.
  ///
  /// In fr, this message translates to:
  /// **'Vous lancez et projetez le match ; d’autres jouent (une classe, deux équipes…).'**
  String get createHostOnlyHint;

  /// No description provided for @createMatchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau match'**
  String get createMatchTitle;

  /// No description provided for @createMaxPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs au plus : {n}'**
  String createMaxPlayers(int n);

  /// No description provided for @createNoPages.
  ///
  /// In fr, this message translates to:
  /// **'Aucune page choisie.'**
  String get createNoPages;

  /// No description provided for @createNotEnough.
  ///
  /// In fr, this message translates to:
  /// **'Pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.'**
  String get createNotEnough;

  /// No description provided for @createPages.
  ///
  /// In fr, this message translates to:
  /// **'Pages au programme'**
  String get createPages;

  /// No description provided for @createPublic.
  ///
  /// In fr, this message translates to:
  /// **'Visible dans les matchs ouverts'**
  String get createPublic;

  /// No description provided for @createPublicHint.
  ///
  /// In fr, this message translates to:
  /// **'Sinon, seuls ceux qui ont le code peuvent entrer.'**
  String get createPublicHint;

  /// No description provided for @createQuestionTime.
  ///
  /// In fr, this message translates to:
  /// **'Temps par question : {seconds} s'**
  String createQuestionTime(int seconds);

  /// No description provided for @createQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Questions : {n}'**
  String createQuestions(int n);

  /// No description provided for @createSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer le match'**
  String get createSubmit;

  /// No description provided for @createWaitQuestions.
  ///
  /// In fr, this message translates to:
  /// **'L’IA prépare encore des questions : patientez un peu, ou réduisez le nombre de questions.'**
  String get createWaitQuestions;

  /// No description provided for @docAddShared.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un document partagé'**
  String get docAddShared;

  /// No description provided for @docAdded.
  ///
  /// In fr, this message translates to:
  /// **'« {name} » ajouté à vos documents.'**
  String docAdded(String name);

  /// No description provided for @docBy.
  ///
  /// In fr, this message translates to:
  /// **'par {owner}'**
  String docBy(String owner);

  /// No description provided for @docDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le document'**
  String get docDelete;

  /// No description provided for @docDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Le document, ses pages et ses questions seront effacés. Les matchs déjà joués gardent leurs questions.'**
  String get docDeleteConfirm;

  /// No description provided for @docForget.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de mes documents'**
  String get docForget;

  /// No description provided for @docFrom.
  ///
  /// In fr, this message translates to:
  /// **'De'**
  String get docFrom;

  /// No description provided for @docImport.
  ///
  /// In fr, this message translates to:
  /// **'Charger un document'**
  String get docImport;

  /// No description provided for @docJustImported.
  ///
  /// In fr, this message translates to:
  /// **'Document chargé ! Cochez les pages au programme, puis « Préparer les questions » ou « Match ».'**
  String get docJustImported;

  /// No description provided for @docMatch.
  ///
  /// In fr, this message translates to:
  /// **'Match'**
  String get docMatch;

  /// No description provided for @docNoPublic.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document public pour l’instant.'**
  String get docNoPublic;

  /// No description provided for @docPractice.
  ///
  /// In fr, this message translates to:
  /// **'M’entraîner'**
  String get docPractice;

  /// No description provided for @docPrepare.
  ///
  /// In fr, this message translates to:
  /// **'Préparer les questions'**
  String get docPrepare;

  /// No description provided for @docPrivate.
  ///
  /// In fr, this message translates to:
  /// **'Privé'**
  String get docPrivate;

  /// No description provided for @docPrivateHint.
  ///
  /// In fr, this message translates to:
  /// **'Vous seul le voyez.'**
  String get docPrivateHint;

  /// No description provided for @docPublic.
  ///
  /// In fr, this message translates to:
  /// **'Public'**
  String get docPublic;

  /// No description provided for @docPublicHint.
  ///
  /// In fr, this message translates to:
  /// **'Tous les joueurs le trouvent dans les documents publics. Ses questions restent visibles de vous seul.'**
  String get docPublicHint;

  /// No description provided for @docPublicLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Documents publics'**
  String get docPublicLibrary;

  /// No description provided for @docRename.
  ///
  /// In fr, this message translates to:
  /// **'Renommer'**
  String get docRename;

  /// No description provided for @docSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un titre'**
  String get docSearch;

  /// No description provided for @docSelectAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout cocher'**
  String get docSelectAll;

  /// No description provided for @docSelectHint.
  ///
  /// In fr, this message translates to:
  /// **'Cochez les pages au programme pour préparer leurs questions, créer un match ou un tournoi, ou vous entraîner.'**
  String get docSelectHint;

  /// No description provided for @docSelectNone.
  ///
  /// In fr, this message translates to:
  /// **'Tout décocher'**
  String get docSelectNone;

  /// No description provided for @docSelectRange.
  ///
  /// In fr, this message translates to:
  /// **'Choisir de… à…'**
  String get docSelectRange;

  /// No description provided for @docSelected.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucune page choisie} =1{1 page choisie} other{{count} pages choisies}}'**
  String docSelected(int count);

  /// No description provided for @docShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get docShare;

  /// No description provided for @docShareCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de partage'**
  String get docShareCode;

  /// No description provided for @docShareHint.
  ///
  /// In fr, this message translates to:
  /// **'Dans Génie en herbe : Documents → menu → Ajouter un document partagé, puis saisir ce code.'**
  String get docShareHint;

  /// No description provided for @docShareText.
  ///
  /// In fr, this message translates to:
  /// **'Je partage le document « {name} » sur Génie en herbe. Code : {code}'**
  String docShareText(String name, String code);

  /// No description provided for @docShared.
  ///
  /// In fr, this message translates to:
  /// **'Partagé par code'**
  String get docShared;

  /// No description provided for @docSharedHint.
  ///
  /// In fr, this message translates to:
  /// **'Ceux qui ont son code peuvent l’ajouter, le lire et jouer dessus.'**
  String get docSharedHint;

  /// No description provided for @docTo.
  ///
  /// In fr, this message translates to:
  /// **'À'**
  String get docTo;

  /// No description provided for @docTournament.
  ///
  /// In fr, this message translates to:
  /// **'Tournoi'**
  String get docTournament;

  /// No description provided for @docUnits.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucune page} =1{1 {unit, select, slide{diapositive} sheet{feuille} part{partie} other{page}}} other{{count} {unit, select, slide{diapositives} sheet{feuilles} part{parties} other{pages}}}}'**
  String docUnits(int count, String unit);

  /// No description provided for @docVisibility.
  ///
  /// In fr, this message translates to:
  /// **'Visibilité'**
  String get docVisibility;

  /// No description provided for @editorAddOption.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une proposition'**
  String get editorAddOption;

  /// No description provided for @editorExplain.
  ///
  /// In fr, this message translates to:
  /// **'Explication (facultative)'**
  String get editorExplain;

  /// No description provided for @editorNeedAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Cochez une proposition remplie comme bonne réponse.'**
  String get editorNeedAnswer;

  /// No description provided for @editorNeedOptions.
  ///
  /// In fr, this message translates to:
  /// **'Il faut au moins deux propositions.'**
  String get editorNeedOptions;

  /// No description provided for @editorOption.
  ///
  /// In fr, this message translates to:
  /// **'Proposition {n}'**
  String editorOption(int n);

  /// No description provided for @editorOptionsHint.
  ///
  /// In fr, this message translates to:
  /// **'Cochez la bonne réponse.'**
  String get editorOptionsHint;

  /// No description provided for @editorPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Question'**
  String get editorPrompt;

  /// No description provided for @editorPromptTooShort.
  ///
  /// In fr, this message translates to:
  /// **'La question est trop courte.'**
  String get editorPromptTooShort;

  /// No description provided for @errBadCode.
  ///
  /// In fr, this message translates to:
  /// **'Code incorrect ou expiré.'**
  String get errBadCode;

  /// No description provided for @errBanned.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte joueur est suspendu.'**
  String get errBanned;

  /// No description provided for @errCorrupt.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier est illisible ou abîmé.'**
  String get errCorrupt;

  /// No description provided for @errEmptyFile.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier ne contient pas de texte.'**
  String get errEmptyFile;

  /// No description provided for @errEncrypted.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier est protégé par un mot de passe.'**
  String get errEncrypted;

  /// No description provided for @errFull.
  ///
  /// In fr, this message translates to:
  /// **'C’est complet.'**
  String get errFull;

  /// No description provided for @errHandTaken.
  ///
  /// In fr, this message translates to:
  /// **'Trop tard : un autre joueur a pris la main.'**
  String get errHandTaken;

  /// No description provided for @errHost.
  ///
  /// In fr, this message translates to:
  /// **'Vous organisez ce match sans y jouer.'**
  String get errHost;

  /// No description provided for @errLegacyOffice.
  ///
  /// In fr, this message translates to:
  /// **'Ancien format Office (.doc, .ppt, .xls) : enregistrez-le en .docx, .pptx, .xlsx ou PDF.'**
  String get errLegacyOffice;

  /// No description provided for @errLocked.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez plus répondre à cette question.'**
  String get errLocked;

  /// No description provided for @errNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion Internet.'**
  String get errNetwork;

  /// No description provided for @errNoHand.
  ///
  /// In fr, this message translates to:
  /// **'Vous n’avez plus la main.'**
  String get errNoHand;

  /// No description provided for @errNoText.
  ///
  /// In fr, this message translates to:
  /// **'Aucun texte lisible : un document scanné doit être lu par la reconnaissance de texte (photos de pages, sur Android).'**
  String get errNoText;

  /// No description provided for @errPages.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez des pages valables.'**
  String get errPages;

  /// No description provided for @errQuestions.
  ///
  /// In fr, this message translates to:
  /// **'Ces pages ne donnent pas assez de questions : ajoutez des pages, ou réduisez le nombre de questions.'**
  String get errQuestions;

  /// No description provided for @errQuestionsPending.
  ///
  /// In fr, this message translates to:
  /// **'Les questions de ces pages sont en préparation : réessayez dans une minute.'**
  String get errQuestionsPending;

  /// No description provided for @errRateLimited.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessayez dans quelques minutes.'**
  String get errRateLimited;

  /// No description provided for @errScanner.
  ///
  /// In fr, this message translates to:
  /// **'Le scanner de documents n’est pas disponible sur ce téléphone.'**
  String get errScanner;

  /// No description provided for @errServer.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur ne répond pas correctement. Réessayez plus tard.'**
  String get errServer;

  /// No description provided for @errServerBusy.
  ///
  /// In fr, this message translates to:
  /// **'Trop de parties en cours en ce moment. Réessayez dans quelques minutes.'**
  String get errServerBusy;

  /// No description provided for @errTooLarge.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier est trop volumineux (40 Mo au plus).'**
  String get errTooLarge;

  /// No description provided for @errTooLate.
  ///
  /// In fr, this message translates to:
  /// **'Le temps est écoulé.'**
  String get errTooLate;

  /// No description provided for @errUnknownCode.
  ///
  /// In fr, this message translates to:
  /// **'Aucun match ni tournoi avec ce code.'**
  String get errUnknownCode;

  /// No description provided for @errUnsupported.
  ///
  /// In fr, this message translates to:
  /// **'Format non pris en charge.'**
  String get errUnsupported;

  /// No description provided for @eventDuelReady.
  ///
  /// In fr, this message translates to:
  /// **'Tournoi : votre duel vous attend !'**
  String get eventDuelReady;

  /// No description provided for @eventGroupJoined.
  ///
  /// In fr, this message translates to:
  /// **'{pseudo} a rejoint le groupe « {name} »'**
  String eventGroupJoined(String pseudo, String name);

  /// No description provided for @eventInvitation.
  ///
  /// In fr, this message translates to:
  /// **'{captain} vous invite dans l’équipe « {team} »'**
  String eventInvitation(String captain, String team);

  /// No description provided for @eventRematch.
  ///
  /// In fr, this message translates to:
  /// **'Revanche proposée : code {code}'**
  String eventRematch(String code);

  /// No description provided for @eventRequest.
  ///
  /// In fr, this message translates to:
  /// **'{pseudo} demande à entrer dans votre équipe'**
  String eventRequest(String pseudo);

  /// No description provided for @eventSee.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get eventSee;

  /// No description provided for @eventTournamentInvitation.
  ///
  /// In fr, this message translates to:
  /// **'{who} vous invite au tournoi « {name} »'**
  String eventTournamentInvitation(String who, String name);

  /// No description provided for @groupBy.
  ///
  /// In fr, this message translates to:
  /// **'créé par {owner}'**
  String groupBy(String owner);

  /// No description provided for @groupCode.
  ///
  /// In fr, this message translates to:
  /// **'Code du groupe'**
  String get groupCode;

  /// No description provided for @groupCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer un groupe'**
  String get groupCreate;

  /// No description provided for @groupDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le groupe'**
  String get groupDelete;

  /// No description provided for @groupDeleteHint.
  ///
  /// In fr, this message translates to:
  /// **'Le groupe disparaît pour tous ses membres.'**
  String get groupDeleteHint;

  /// No description provided for @groupJoin.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre un groupe'**
  String get groupJoin;

  /// No description provided for @groupJoined.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez rejoint le groupe « {name} ».'**
  String groupJoined(String name);

  /// No description provided for @groupLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter le groupe'**
  String get groupLeave;

  /// No description provided for @groupMembers.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucun membre} =1{1 membre} other{{count} membres}}'**
  String groupMembers(int count);

  /// No description provided for @groupMembersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get groupMembersTitle;

  /// No description provided for @groupMine.
  ///
  /// In fr, this message translates to:
  /// **'créé par vous'**
  String get groupMine;

  /// No description provided for @groupName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du groupe'**
  String get groupName;

  /// No description provided for @groupNotAGroup.
  ///
  /// In fr, this message translates to:
  /// **'Ce code n’est pas celui d’un groupe.'**
  String get groupNotAGroup;

  /// No description provided for @groupOwner.
  ///
  /// In fr, this message translates to:
  /// **'créateur'**
  String get groupOwner;

  /// No description provided for @groupRemoveMember.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {pseudo} du groupe ?'**
  String groupRemoveMember(String pseudo);

  /// No description provided for @groupRename.
  ///
  /// In fr, this message translates to:
  /// **'Renommer le groupe'**
  String get groupRename;

  /// No description provided for @groupRenewCode.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau code'**
  String get groupRenewCode;

  /// No description provided for @groupRenewCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'L’ancien code ne permettra plus d’entrer dans le groupe. Les membres actuels restent.'**
  String get groupRenewCodeHint;

  /// No description provided for @groupShareHint.
  ///
  /// In fr, this message translates to:
  /// **'Dans Génie en herbe : Jouer → Rejoindre, puis saisir ce code (ou ouvrir le lien).'**
  String get groupShareHint;

  /// No description provided for @groupShareText.
  ///
  /// In fr, this message translates to:
  /// **'Rejoins le groupe « {name} » sur Génie en herbe. Code : {code}'**
  String groupShareText(String name, String code);

  /// No description provided for @groupTransfer.
  ///
  /// In fr, this message translates to:
  /// **'Confier le groupe à {pseudo} ?'**
  String groupTransfer(String pseudo);

  /// No description provided for @groupTransferAction.
  ///
  /// In fr, this message translates to:
  /// **'Confier le groupe'**
  String get groupTransferAction;

  /// No description provided for @groupTransferHint.
  ///
  /// In fr, this message translates to:
  /// **'Ce joueur deviendra le créateur : lui seul pourra gérer le groupe.'**
  String get groupTransferHint;

  /// No description provided for @groupsHint.
  ///
  /// In fr, this message translates to:
  /// **'Une classe, un club : invitez tout le groupe d’un geste'**
  String get groupsHint;

  /// No description provided for @groupsIntro.
  ///
  /// In fr, this message translates to:
  /// **'Créez un groupe (une classe, un club), partagez son code : chacun le saisit une fois. Vous pourrez ensuite inviter tout le groupe à un match, ou lui réserver un tournoi.'**
  String get groupsIntro;

  /// No description provided for @groupsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes groupes'**
  String get groupsTitle;

  /// No description provided for @homeScreenBody.
  ///
  /// In fr, this message translates to:
  /// **'Touchez Partager (le carré avec une flèche), puis « Sur l’écran d’accueil ». L’application s’ouvrira en plein écran et vos données seront mieux conservées.'**
  String get homeScreenBody;

  /// No description provided for @homeScreenDismiss.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get homeScreenDismiss;

  /// No description provided for @homeScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez l’application à l’écran d’accueil'**
  String get homeScreenTitle;

  /// No description provided for @importBlankPage.
  ///
  /// In fr, this message translates to:
  /// **'(page sans texte)'**
  String get importBlankPage;

  /// No description provided for @importChars.
  ///
  /// In fr, this message translates to:
  /// **'{count} caractères'**
  String importChars(int count);

  /// No description provided for @importDocTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre du document'**
  String get importDocTitle;

  /// No description provided for @importDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Vous aviez déjà chargé ce document : le voici.'**
  String get importDuplicate;

  /// No description provided for @importEmptyPages.
  ///
  /// In fr, this message translates to:
  /// **'{count} page(s) sans texte (pages blanches, images)'**
  String importEmptyPages(int count);

  /// No description provided for @importFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un fichier'**
  String get importFile;

  /// No description provided for @importFileHint.
  ///
  /// In fr, this message translates to:
  /// **'PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, texte, HTML, RTF'**
  String get importFileHint;

  /// No description provided for @importIntro.
  ///
  /// In fr, this message translates to:
  /// **'Le texte est lu sur votre téléphone, page par page, puis envoyé au serveur. Le fichier lui-même ne quitte pas le téléphone.'**
  String get importIntro;

  /// No description provided for @importLang.
  ///
  /// In fr, this message translates to:
  /// **'Langue du document'**
  String get importLang;

  /// No description provided for @importLangAuto.
  ///
  /// In fr, this message translates to:
  /// **'Reconnue automatiquement'**
  String get importLangAuto;

  /// No description provided for @importLangHint.
  ///
  /// In fr, this message translates to:
  /// **'Les questions sont rédigées dans cette langue.'**
  String get importLangHint;

  /// No description provided for @importMorePages.
  ///
  /// In fr, this message translates to:
  /// **'… et {count} autre(s)'**
  String importMorePages(int count);

  /// No description provided for @importNeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Donnez un titre au document.'**
  String get importNeedTitle;

  /// No description provided for @importOther.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un autre document'**
  String get importOther;

  /// No description provided for @importPartsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ce document n’a pas de pages : il est découpé en parties.'**
  String get importPartsHint;

  /// No description provided for @importPaste.
  ///
  /// In fr, this message translates to:
  /// **'Coller un texte'**
  String get importPaste;

  /// No description provided for @importPasteHint.
  ///
  /// In fr, this message translates to:
  /// **'Collez ici le texte du cours…'**
  String get importPasteHint;

  /// No description provided for @importPasteSub.
  ///
  /// In fr, this message translates to:
  /// **'Découpé en parties d’environ 3 000 caractères.'**
  String get importPasteSub;

  /// No description provided for @importPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Les documents sont privés par défaut. Vous pouvez les partager par un code, ou les rendre publics.'**
  String get importPrivacy;

  /// No description provided for @importReading.
  ///
  /// In fr, this message translates to:
  /// **'Lecture du fichier…'**
  String get importReading;

  /// No description provided for @importReadingPages.
  ///
  /// In fr, this message translates to:
  /// **'Lecture des pages : {done} / {total}'**
  String importReadingPages(int done, int total);

  /// No description provided for @importRecognizing.
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance du texte : {done} / {total}'**
  String importRecognizing(int done, int total);

  /// No description provided for @importScan.
  ///
  /// In fr, this message translates to:
  /// **'Photographier des pages'**
  String get importScan;

  /// No description provided for @importScanHint.
  ///
  /// In fr, this message translates to:
  /// **'Un manuel ou un cahier : une photo par page, le texte est reconnu sur le téléphone.'**
  String get importScanHint;

  /// No description provided for @importScanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pages photographiées'**
  String get importScanTitle;

  /// No description provided for @importSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get importSend;

  /// No description provided for @importSending.
  ///
  /// In fr, this message translates to:
  /// **'Envoi du document…'**
  String get importSending;

  /// No description provided for @importSendingPages.
  ///
  /// In fr, this message translates to:
  /// **'Envoi : {done} / {total} pages'**
  String importSendingPages(int done, int total);

  /// No description provided for @importTitle.
  ///
  /// In fr, this message translates to:
  /// **'Charger un document'**
  String get importTitle;

  /// No description provided for @inviteBusy.
  ///
  /// In fr, this message translates to:
  /// **'déjà dans une partie : {names}'**
  String inviteBusy(String names);

  /// No description provided for @inviteButton.
  ///
  /// In fr, this message translates to:
  /// **'Inviter des joueurs'**
  String get inviteButton;

  /// No description provided for @inviteDeclined.
  ///
  /// In fr, this message translates to:
  /// **'a refusé'**
  String get inviteDeclined;

  /// No description provided for @inviteGroup.
  ///
  /// In fr, this message translates to:
  /// **'Inviter le groupe'**
  String get inviteGroup;

  /// No description provided for @inviteNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune invitation envoyée'**
  String get inviteNone;

  /// No description provided for @invitePending.
  ///
  /// In fr, this message translates to:
  /// **'invité'**
  String get invitePending;

  /// No description provided for @invitePlayersIn.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{personne dans la salle} =1{1 joueur déjà dans la salle} other{{count} joueurs déjà dans la salle}}'**
  String invitePlayersIn(int count);

  /// No description provided for @invitePolicyAll.
  ///
  /// In fr, this message translates to:
  /// **'De tout le monde'**
  String get invitePolicyAll;

  /// No description provided for @invitePolicyKnown.
  ///
  /// In fr, this message translates to:
  /// **'De mes joueurs et de mes groupes seulement'**
  String get invitePolicyKnown;

  /// No description provided for @invitePolicyNone.
  ///
  /// In fr, this message translates to:
  /// **'De personne'**
  String get invitePolicyNone;

  /// No description provided for @invitePolicyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir les invitations'**
  String get invitePolicyTitle;

  /// No description provided for @inviteReceived.
  ///
  /// In fr, this message translates to:
  /// **'{who} vous invite à un match'**
  String inviteReceived(String who);

  /// No description provided for @inviteSelected.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Inviter} =1{Inviter 1 joueur} other{Inviter {count} joueurs}}'**
  String inviteSelected(int count);

  /// No description provided for @inviteSent.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun joueur invité} =1{1 joueur invité} other{{count} joueurs invités}}'**
  String inviteSent(int count);

  /// No description provided for @inviteSkipAlready.
  ///
  /// In fr, this message translates to:
  /// **'{count} déjà là ou déjà invité(s)'**
  String inviteSkipAlready(int count);

  /// No description provided for @inviteSkipGroup.
  ///
  /// In fr, this message translates to:
  /// **'{count} hors du groupe du tournoi'**
  String inviteSkipGroup(int count);

  /// No description provided for @inviteSkipLimit.
  ///
  /// In fr, this message translates to:
  /// **'limite d’invitations atteinte pour cette heure'**
  String get inviteSkipLimit;

  /// No description provided for @inviteSkipRefused.
  ///
  /// In fr, this message translates to:
  /// **'{count} n’accepte(nt) pas les invitations'**
  String inviteSkipRefused(int count);

  /// No description provided for @libraryEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Chargez un cours ou un manuel avec « Charger un document », ajoutez un document partagé par son code, ou parcourez les documents publics.'**
  String get libraryEmptyBody;

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre bibliothèque est vide'**
  String get libraryEmptyTitle;

  /// No description provided for @libraryMine.
  ///
  /// In fr, this message translates to:
  /// **'Mes documents'**
  String get libraryMine;

  /// No description provided for @libraryShared.
  ///
  /// In fr, this message translates to:
  /// **'Partagés avec moi'**
  String get libraryShared;

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes documents'**
  String get libraryTitle;

  /// No description provided for @loadError.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu n’a pas pu être chargé.'**
  String get loadError;

  /// No description provided for @lobbyCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Ce match a été annulé.'**
  String get lobbyCancelled;

  /// No description provided for @lobbyCode.
  ///
  /// In fr, this message translates to:
  /// **'Code du match'**
  String get lobbyCode;

  /// No description provided for @lobbyCreator.
  ///
  /// In fr, this message translates to:
  /// **'créateur'**
  String get lobbyCreator;

  /// No description provided for @lobbyHostedBy.
  ///
  /// In fr, this message translates to:
  /// **'Organisé par {pseudo}, qui ne joue pas'**
  String lobbyHostedBy(String pseudo);

  /// No description provided for @lobbyKick.
  ///
  /// In fr, this message translates to:
  /// **'Retirer du match'**
  String get lobbyKick;

  /// No description provided for @lobbyLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get lobbyLeave;

  /// No description provided for @lobbyLeaveConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Quitter ce match ?'**
  String get lobbyLeaveConfirm;

  /// No description provided for @lobbyLeaveRunning.
  ///
  /// In fr, this message translates to:
  /// **'Si vous quittez un match en cours, vous l’abandonnez.'**
  String get lobbyLeaveRunning;

  /// No description provided for @lobbyNeedPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Il faut au moins 2 joueurs.'**
  String get lobbyNeedPlayers;

  /// No description provided for @lobbyNoTeam.
  ///
  /// In fr, this message translates to:
  /// **'Sans équipe'**
  String get lobbyNoTeam;

  /// No description provided for @lobbyNoTeamHint.
  ///
  /// In fr, this message translates to:
  /// **'Les joueurs sans équipe ne jouent pas : demandez à entrer dans une équipe, ou créez-la.'**
  String get lobbyNoTeamHint;

  /// No description provided for @lobbyPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs'**
  String get lobbyPlayers;

  /// No description provided for @lobbyRevise.
  ///
  /// In fr, this message translates to:
  /// **'Réviser les pages'**
  String get lobbyRevise;

  /// No description provided for @lobbySettings.
  ///
  /// In fr, this message translates to:
  /// **'{n} questions · {seconds} s par question · main : {hand} s'**
  String lobbySettings(int n, int seconds, String hand);

  /// No description provided for @lobbyShareHint.
  ///
  /// In fr, this message translates to:
  /// **'Les autres joueurs saisissent ce code dans Jouer → Rejoindre, ou scannent le QR code avec l’appareil photo.'**
  String get lobbyShareHint;

  /// No description provided for @lobbyShareText.
  ///
  /// In fr, this message translates to:
  /// **'Rejoins-moi pour un match de Génie en herbe ({passages}) ! Code : {code} {link}'**
  String lobbyShareText(String passages, String code, String link);

  /// No description provided for @lobbyShareWhatsApp.
  ///
  /// In fr, this message translates to:
  /// **'Inviter par WhatsApp'**
  String get lobbyShareWhatsApp;

  /// No description provided for @lobbyStart.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le match'**
  String get lobbyStart;

  /// No description provided for @lobbyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Salle d’attente'**
  String get lobbyTitle;

  /// No description provided for @lobbyWaitCreator.
  ///
  /// In fr, this message translates to:
  /// **'En attente du lancement par {name}…'**
  String lobbyWaitCreator(String name);

  /// No description provided for @navDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Documents'**
  String get navDocuments;

  /// No description provided for @navPlay.
  ///
  /// In fr, this message translates to:
  /// **'Jouer'**
  String get navPlay;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @offlineHint.
  ///
  /// In fr, this message translates to:
  /// **'Vos pages déjà lues restent disponibles ici : relisez-les et entraînez-vous.'**
  String get offlineHint;

  /// No description provided for @offlineNoPages.
  ///
  /// In fr, this message translates to:
  /// **'Aucune page gardée sur cet appareil pour l’instant : ouvrez des pages une fois en ligne.'**
  String get offlineNoPages;

  /// No description provided for @offlineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion'**
  String get offlineTitle;

  /// No description provided for @onlineAccountHint.
  ///
  /// In fr, this message translates to:
  /// **'Il faut un numéro de téléphone (code reçu par WhatsApp) et un pseudo.'**
  String get onlineAccountHint;

  /// No description provided for @onlineBecomePlayer.
  ///
  /// In fr, this message translates to:
  /// **'Devenir joueur'**
  String get onlineBecomePlayer;

  /// No description provided for @onlineBy.
  ///
  /// In fr, this message translates to:
  /// **'par {name}'**
  String onlineBy(String name);

  /// No description provided for @onlineCreateMatch.
  ///
  /// In fr, this message translates to:
  /// **'Créer un match'**
  String get onlineCreateMatch;

  /// No description provided for @onlineCreateTournament.
  ///
  /// In fr, this message translates to:
  /// **'Créer un tournoi'**
  String get onlineCreateTournament;

  /// No description provided for @onlineCurrentMatch.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez un match en cours'**
  String get onlineCurrentMatch;

  /// No description provided for @onlineCurrentTournament.
  ///
  /// In fr, this message translates to:
  /// **'Vous participez au tournoi « {name} »'**
  String onlineCurrentTournament(String name);

  /// No description provided for @onlineHistory.
  ///
  /// In fr, this message translates to:
  /// **'Mes matchs'**
  String get onlineHistory;

  /// No description provided for @onlineIntro.
  ///
  /// In fr, this message translates to:
  /// **'Affrontez d’autres joueurs, seul ou en équipe, sur les pages de vos documents. Le premier qui prend la main répond ; une bonne réponse rapporte 10 points, une erreur en coûte 5.'**
  String get onlineIntro;

  /// No description provided for @onlineInvitations.
  ///
  /// In fr, this message translates to:
  /// **'Invitations'**
  String get onlineInvitations;

  /// No description provided for @onlineJoin.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get onlineJoin;

  /// No description provided for @onlineJoinHint.
  ///
  /// In fr, this message translates to:
  /// **'Code à 6 caractères'**
  String get onlineJoinHint;

  /// No description provided for @onlineJoinTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre avec un code'**
  String get onlineJoinTitle;

  /// No description provided for @onlineModeSolo.
  ///
  /// In fr, this message translates to:
  /// **'Individuel'**
  String get onlineModeSolo;

  /// No description provided for @onlineModeTeam.
  ///
  /// In fr, this message translates to:
  /// **'Par équipes'**
  String get onlineModeTeam;

  /// No description provided for @onlineMyTournaments.
  ///
  /// In fr, this message translates to:
  /// **'Mes tournois'**
  String get onlineMyTournaments;

  /// No description provided for @onlineNoHistory.
  ///
  /// In fr, this message translates to:
  /// **'Vos matchs terminés s’afficheront ici.'**
  String get onlineNoHistory;

  /// No description provided for @onlineNoOpenMatch.
  ///
  /// In fr, this message translates to:
  /// **'Aucun match ouvert pour l’instant. Créez-en un et partagez son code.'**
  String get onlineNoOpenMatch;

  /// No description provided for @onlineOpenMatches.
  ///
  /// In fr, this message translates to:
  /// **'Matchs ouverts'**
  String get onlineOpenMatches;

  /// No description provided for @onlineOpenTournaments.
  ///
  /// In fr, this message translates to:
  /// **'Tournois ouverts'**
  String get onlineOpenTournaments;

  /// No description provided for @onlineOptional.
  ///
  /// In fr, this message translates to:
  /// **'Un compte est nécessaire pour charger des documents et jouer.'**
  String get onlineOptional;

  /// No description provided for @onlinePlayers.
  ///
  /// In fr, this message translates to:
  /// **'{players}/{max} joueurs'**
  String onlinePlayers(int players, int max);

  /// No description provided for @onlineProjection.
  ///
  /// In fr, this message translates to:
  /// **'Écran de projection'**
  String get onlineProjection;

  /// No description provided for @onlineProjectionHint.
  ///
  /// In fr, this message translates to:
  /// **'Affichez un match en grand (vidéoprojecteur, télévision), sans compte.'**
  String get onlineProjectionHint;

  /// No description provided for @onlineRealtimeOff.
  ///
  /// In fr, this message translates to:
  /// **'Connexion lente : l’affichage peut avoir un peu de retard.'**
  String get onlineRealtimeOff;

  /// No description provided for @onlineResume.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get onlineResume;

  /// No description provided for @onlineStats.
  ///
  /// In fr, this message translates to:
  /// **'{played, plural, =0{Aucun match} =1{1 match} other{{played} matchs}} · {won, plural, =0{aucun gagné} =1{1 gagné} other{{won} gagnés}}'**
  String onlineStats(int played, int won);

  /// No description provided for @onlineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Jouer'**
  String get onlineTitle;

  /// No description provided for @pageAiDone.
  ///
  /// In fr, this message translates to:
  /// **'IA ✓'**
  String get pageAiDone;

  /// No description provided for @pageAiFailed.
  ///
  /// In fr, this message translates to:
  /// **'IA indisponible'**
  String get pageAiFailed;

  /// No description provided for @pageAiRunning.
  ///
  /// In fr, this message translates to:
  /// **'IA en cours…'**
  String get pageAiRunning;

  /// No description provided for @pageEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Page sans texte'**
  String get pageEmpty;

  /// No description provided for @pageNext.
  ///
  /// In fr, this message translates to:
  /// **'Page suivante'**
  String get pageNext;

  /// No description provided for @pageOfflineCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copie gardée sur cet appareil (pas de réseau).'**
  String get pageOfflineCopy;

  /// No description provided for @pagePrevious.
  ///
  /// In fr, this message translates to:
  /// **'Page précédente'**
  String get pagePrevious;

  /// No description provided for @pageRead.
  ///
  /// In fr, this message translates to:
  /// **'Lire la page'**
  String get pageRead;

  /// No description provided for @pageValidated.
  ///
  /// In fr, this message translates to:
  /// **'{count} validée(s)'**
  String pageValidated(int count);

  /// No description provided for @pagesAiPending.
  ///
  /// In fr, this message translates to:
  /// **'{ready} question(s) prête(s) ; l’IA prépare encore {pages} page(s)…'**
  String pagesAiPending(int ready, int pages);

  /// No description provided for @pagesClear.
  ///
  /// In fr, this message translates to:
  /// **'Retirer ces pages'**
  String get pagesClear;

  /// No description provided for @pagesReady.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucune question prête} =1{1 question prête} other{{count} questions prêtes}}'**
  String pagesReady(int count);

  /// No description provided for @pickerConfirm.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Valider} =1{Valider 1 page} other{Valider {count} pages}}'**
  String pickerConfirm(int count);

  /// No description provided for @pickerHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un document, puis cochez ses pages. Leurs questions sont préparées aussitôt.'**
  String get pickerHint;

  /// No description provided for @pickerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir les pages'**
  String get pickerTitle;

  /// No description provided for @playAnswerWas.
  ///
  /// In fr, this message translates to:
  /// **'Réponse : {answer}'**
  String playAnswerWas(String answer);

  /// No description provided for @playAnsweredWrong.
  ///
  /// In fr, this message translates to:
  /// **'{name} s’est trompé : −5'**
  String playAnsweredWrong(String name);

  /// No description provided for @playBuzz.
  ///
  /// In fr, this message translates to:
  /// **'Je réponds !'**
  String get playBuzz;

  /// No description provided for @playCountdown.
  ///
  /// In fr, this message translates to:
  /// **'Prêts ?'**
  String get playCountdown;

  /// No description provided for @playFromText.
  ///
  /// In fr, this message translates to:
  /// **'Tiré du texte'**
  String get playFromText;

  /// No description provided for @playHandLost.
  ///
  /// In fr, this message translates to:
  /// **'{name} a laissé filer la main : −5'**
  String playHandLost(String name);

  /// No description provided for @playHandOf.
  ///
  /// In fr, this message translates to:
  /// **'{name} a la main'**
  String playHandOf(String name);

  /// No description provided for @playLeft.
  ///
  /// In fr, this message translates to:
  /// **'a quitté'**
  String get playLeft;

  /// No description provided for @playLocked.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez plus répondre à cette question'**
  String get playLocked;

  /// No description provided for @playLockedTeam.
  ///
  /// In fr, this message translates to:
  /// **'Votre équipe ne peut plus répondre à cette question'**
  String get playLockedTeam;

  /// No description provided for @playNobody.
  ///
  /// In fr, this message translates to:
  /// **'Personne n’a trouvé'**
  String get playNobody;

  /// No description provided for @playPaused.
  ///
  /// In fr, this message translates to:
  /// **'Chrono en pause'**
  String get playPaused;

  /// No description provided for @playPoints.
  ///
  /// In fr, this message translates to:
  /// **'{points} pts'**
  String playPoints(int points);

  /// No description provided for @playQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question {index} sur {total}'**
  String playQuestion(int index, int total);

  /// No description provided for @playScores.
  ///
  /// In fr, this message translates to:
  /// **'Scores'**
  String get playScores;

  /// No description provided for @playSpectator.
  ///
  /// In fr, this message translates to:
  /// **'Vous regardez ce match'**
  String get playSpectator;

  /// No description provided for @playTiebreak.
  ///
  /// In fr, this message translates to:
  /// **'Question décisive : la première bonne réponse l’emporte'**
  String get playTiebreak;

  /// No description provided for @playWonBy.
  ///
  /// In fr, this message translates to:
  /// **'{name} a trouvé'**
  String playWonBy(String name);

  /// No description provided for @playYourHand.
  ///
  /// In fr, this message translates to:
  /// **'À vous ! Choisissez la réponse'**
  String get playYourHand;

  /// No description provided for @practiceAgain.
  ///
  /// In fr, this message translates to:
  /// **'D’autres questions'**
  String get practiceAgain;

  /// No description provided for @practiceFalse.
  ///
  /// In fr, this message translates to:
  /// **'Faux'**
  String get practiceFalse;

  /// No description provided for @practiceFinish.
  ///
  /// In fr, this message translates to:
  /// **'Voir le résultat'**
  String get practiceFinish;

  /// No description provided for @practiceLanguage.
  ///
  /// In fr, this message translates to:
  /// **'L’entraînement sur le téléphone ne sait faire des questions qu’en français et en anglais.'**
  String get practiceLanguage;

  /// No description provided for @practiceNext.
  ///
  /// In fr, this message translates to:
  /// **'Question suivante'**
  String get practiceNext;

  /// No description provided for @practiceNoPages.
  ///
  /// In fr, this message translates to:
  /// **'Ces pages ne sont pas disponibles sans réseau : ouvrez-les une fois en ligne.'**
  String get practiceNoPages;

  /// No description provided for @practiceRight.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse !'**
  String get practiceRight;

  /// No description provided for @practiceScore.
  ///
  /// In fr, this message translates to:
  /// **'{score} bonne(s) réponse(s) sur {total}'**
  String practiceScore(int score, int total);

  /// No description provided for @practiceThesePages.
  ///
  /// In fr, this message translates to:
  /// **'M’entraîner sur ces pages'**
  String get practiceThesePages;

  /// No description provided for @practiceThisPage.
  ///
  /// In fr, this message translates to:
  /// **'M’entraîner sur cette page'**
  String get practiceThisPage;

  /// No description provided for @practiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entraînement'**
  String get practiceTitle;

  /// No description provided for @practiceTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Ces pages sont trop courtes pour un entraînement : choisissez-en davantage.'**
  String get practiceTooShort;

  /// No description provided for @practiceTrue.
  ///
  /// In fr, this message translates to:
  /// **'Vrai'**
  String get practiceTrue;

  /// No description provided for @practiceWrong.
  ///
  /// In fr, this message translates to:
  /// **'Ce n’est pas ça.'**
  String get practiceWrong;

  /// No description provided for @profileAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get profileAccount;

  /// No description provided for @profileDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte joueur'**
  String get profileDelete;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Votre pseudo, votre historique et vos documents seront effacés, et vous quitterez la partie en cours.'**
  String get profileDeleteConfirm;

  /// No description provided for @profileDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Compte joueur supprimé'**
  String get profileDeleted;

  /// No description provided for @profileRename.
  ///
  /// In fr, this message translates to:
  /// **'Changer de pseudo'**
  String get profileRename;

  /// No description provided for @profileSignOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get profileSignOut;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileTournamentsWon.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun tournoi gagné} =1{1 tournoi gagné} other{{count} tournois gagnés}}'**
  String profileTournamentsWon(int count);

  /// No description provided for @projectionCodePrompt.
  ///
  /// In fr, this message translates to:
  /// **'Code du match à afficher'**
  String get projectionCodePrompt;

  /// No description provided for @projectionShow.
  ///
  /// In fr, this message translates to:
  /// **'Afficher'**
  String get projectionShow;

  /// No description provided for @projectionWaiting.
  ///
  /// In fr, this message translates to:
  /// **'En attente des joueurs — code {code}'**
  String projectionWaiting(String code);

  /// No description provided for @pseudoHint.
  ///
  /// In fr, this message translates to:
  /// **'3 à 20 caractères, visible par les autres joueurs'**
  String get pseudoHint;

  /// No description provided for @pseudoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get pseudoLabel;

  /// No description provided for @pseudoSave.
  ///
  /// In fr, this message translates to:
  /// **'C’est parti'**
  String get pseudoSave;

  /// No description provided for @pseudoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre pseudo'**
  String get pseudoTitle;

  /// No description provided for @questionsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucune question} =1{1 question} other{{count} questions}}'**
  String questionsCount(int count);

  /// No description provided for @questionsPrepared.
  ///
  /// In fr, this message translates to:
  /// **'Questions prêtes.'**
  String get questionsPrepared;

  /// No description provided for @reminderDay.
  ///
  /// In fr, this message translates to:
  /// **'Rappel : match {when} (code {code}).'**
  String reminderDay(String when, String code);

  /// No description provided for @reminderDropped.
  ///
  /// In fr, this message translates to:
  /// **'Le match {code} a commencé sans vous : vous étiez dans une autre partie.'**
  String reminderDropped(String code);

  /// No description provided for @reminderMoved.
  ///
  /// In fr, this message translates to:
  /// **'Le match {code} est déplacé : {when}.'**
  String reminderMoved(String code, String when);

  /// No description provided for @reminderSoon.
  ///
  /// In fr, this message translates to:
  /// **'Le match {code} commence dans 10 minutes.'**
  String reminderSoon(String code);

  /// No description provided for @reminderStart.
  ///
  /// In fr, this message translates to:
  /// **'C’est l’heure : rejoignez le match {code}.'**
  String reminderStart(String code);

  /// No description provided for @reminderStartCreator.
  ///
  /// In fr, this message translates to:
  /// **'C’est l’heure : lancez le match {code}.'**
  String reminderStartCreator(String code);

  /// No description provided for @report.
  ///
  /// In fr, this message translates to:
  /// **'Signaler ce pseudo'**
  String get report;

  /// No description provided for @reportReason.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi ? (facultatif)'**
  String get reportReason;

  /// No description provided for @reportSent.
  ///
  /// In fr, this message translates to:
  /// **'Signalement envoyé. Merci.'**
  String get reportSent;

  /// No description provided for @resultAbandon.
  ///
  /// In fr, this message translates to:
  /// **'Match arrêté : un camp a quitté la partie.'**
  String get resultAbandon;

  /// No description provided for @resultBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get resultBack;

  /// No description provided for @resultDraw.
  ///
  /// In fr, this message translates to:
  /// **'Égalité'**
  String get resultDraw;

  /// No description provided for @resultFirst.
  ///
  /// In fr, this message translates to:
  /// **'1ᵉʳ'**
  String get resultFirst;

  /// No description provided for @resultIdle.
  ///
  /// In fr, this message translates to:
  /// **'Match clos faute d’activité.'**
  String get resultIdle;

  /// No description provided for @resultRank.
  ///
  /// In fr, this message translates to:
  /// **'{rank}ᵉ'**
  String resultRank(int rank);

  /// No description provided for @resultReadPage.
  ///
  /// In fr, this message translates to:
  /// **'Relire la page'**
  String get resultReadPage;

  /// No description provided for @resultRematch.
  ///
  /// In fr, this message translates to:
  /// **'Revanche'**
  String get resultRematch;

  /// No description provided for @resultRematchSent.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau match créé : les autres joueurs reçoivent le code.'**
  String get resultRematchSent;

  /// No description provided for @resultReview.
  ///
  /// In fr, this message translates to:
  /// **'Revoir les questions'**
  String get resultReview;

  /// No description provided for @resultTiebreak.
  ///
  /// In fr, this message translates to:
  /// **'Départagé par une question décisive.'**
  String get resultTiebreak;

  /// No description provided for @resultTiebreakRule.
  ///
  /// In fr, this message translates to:
  /// **'Égalité parfaite : départagé au règlement (moins d’erreurs, puis rapidité).'**
  String get resultTiebreakRule;

  /// No description provided for @resultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultats'**
  String get resultTitle;

  /// No description provided for @resultWinner.
  ///
  /// In fr, this message translates to:
  /// **'{name} gagne !'**
  String resultWinner(String name);

  /// No description provided for @resultYouWin.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez gagné !'**
  String get resultYouWin;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @reviewAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une question'**
  String get reviewAdd;

  /// No description provided for @reviewDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la question'**
  String get reviewDelete;

  /// No description provided for @reviewEdit.
  ///
  /// In fr, this message translates to:
  /// **'Corriger'**
  String get reviewEdit;

  /// No description provided for @reviewHint.
  ///
  /// In fr, this message translates to:
  /// **'Les questions validées passent en premier dans les matchs.'**
  String get reviewHint;

  /// No description provided for @reviewNone.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de question pour cette page.'**
  String get reviewNone;

  /// No description provided for @reviewPlayed.
  ///
  /// In fr, this message translates to:
  /// **'posée {count} fois'**
  String reviewPlayed(int count);

  /// No description provided for @reviewProposed.
  ///
  /// In fr, this message translates to:
  /// **'À relire'**
  String get reviewProposed;

  /// No description provided for @reviewRegenerate.
  ///
  /// In fr, this message translates to:
  /// **'Régénérer'**
  String get reviewRegenerate;

  /// No description provided for @reviewRegenerateAi.
  ///
  /// In fr, this message translates to:
  /// **'Régénérer avec l’IA'**
  String get reviewRegenerateAi;

  /// No description provided for @reviewRegenerateHint.
  ///
  /// In fr, this message translates to:
  /// **'Les questions non validées de cette page sont remplacées par de nouvelles.'**
  String get reviewRegenerateHint;

  /// No description provided for @reviewRegenerateOffline.
  ///
  /// In fr, this message translates to:
  /// **'Régénérer sans IA'**
  String get reviewRegenerateOffline;

  /// No description provided for @reviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Relire les questions'**
  String get reviewTitle;

  /// No description provided for @reviewValidateAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout valider'**
  String get reviewValidateAll;

  /// No description provided for @reviewValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validée'**
  String get reviewValidated;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @scanCameraDenied.
  ///
  /// In fr, this message translates to:
  /// **'L’accès à la caméra a été refusé. Autorisez-le dans les réglages du téléphone, ou saisissez le code.'**
  String get scanCameraDenied;

  /// No description provided for @scanCameraUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'La caméra n’est pas disponible. Saisissez le code de la partie.'**
  String get scanCameraUnavailable;

  /// No description provided for @scanFromImage.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une image'**
  String get scanFromImage;

  /// No description provided for @scanHint.
  ///
  /// In fr, this message translates to:
  /// **'Visez le QR code affiché dans la salle d’attente du match ou du tournoi.'**
  String get scanHint;

  /// No description provided for @scanNoQrInImage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun QR code de partie dans cette image.'**
  String get scanNoQrInImage;

  /// No description provided for @scanNotAGame.
  ///
  /// In fr, this message translates to:
  /// **'Ce QR code n’est pas celui d’une partie de Génie en herbe.'**
  String get scanNotAGame;

  /// No description provided for @scanQr.
  ///
  /// In fr, this message translates to:
  /// **'Scanner le QR code'**
  String get scanQr;

  /// No description provided for @scanTorch.
  ///
  /// In fr, this message translates to:
  /// **'Lampe'**
  String get scanTorch;

  /// No description provided for @scanTypeCode.
  ///
  /// In fr, this message translates to:
  /// **'Saisir le code'**
  String get scanTypeCode;

  /// No description provided for @scheduleChange.
  ///
  /// In fr, this message translates to:
  /// **'Changer l’heure'**
  String get scheduleChange;

  /// No description provided for @scheduleDate.
  ///
  /// In fr, this message translates to:
  /// **'Jour du match'**
  String get scheduleDate;

  /// No description provided for @scheduleInDays.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{dans moins d’un jour} =1{dans 1 jour} other{dans {count} jours}}'**
  String scheduleInDays(int count);

  /// No description provided for @scheduleInHours.
  ///
  /// In fr, this message translates to:
  /// **'dans {hours} h {minutes} min'**
  String scheduleInHours(int hours, int minutes);

  /// No description provided for @scheduleInMinutes.
  ///
  /// In fr, this message translates to:
  /// **'dans {minutes} min'**
  String scheduleInMinutes(int minutes);

  /// No description provided for @scheduleMoved.
  ///
  /// In fr, this message translates to:
  /// **'Heure changée : les joueurs sont prévenus.'**
  String get scheduleMoved;

  /// No description provided for @scheduleOn.
  ///
  /// In fr, this message translates to:
  /// **'{day} à {time}'**
  String scheduleOn(String day, String time);

  /// No description provided for @scheduleSwitch.
  ///
  /// In fr, this message translates to:
  /// **'Programmer le match'**
  String get scheduleSwitch;

  /// No description provided for @scheduleSwitchHint.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le jour et l’heure : les joueurs s’inscrivent à l’avance et reçoivent des rappels.'**
  String get scheduleSwitchHint;

  /// No description provided for @scheduleTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure du match'**
  String get scheduleTime;

  /// No description provided for @scheduleToday.
  ///
  /// In fr, this message translates to:
  /// **'aujourd’hui à {time}'**
  String scheduleToday(String time);

  /// No description provided for @scheduleTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'demain à {time}'**
  String scheduleTomorrow(String time);

  /// No description provided for @scheduleTooSoon.
  ///
  /// In fr, this message translates to:
  /// **'Programmez le match au moins 5 minutes à l’avance.'**
  String get scheduleTooSoon;

  /// No description provided for @scheduledFor.
  ///
  /// In fr, this message translates to:
  /// **'Prévu {when}'**
  String scheduledFor(String when);

  /// No description provided for @scheduledLobbyHint.
  ///
  /// In fr, this message translates to:
  /// **'Inscrivez-vous et invitez dès maintenant ; rappels la veille et 10 minutes avant.'**
  String get scheduledLobbyHint;

  /// No description provided for @scheduledTitle.
  ///
  /// In fr, this message translates to:
  /// **'Matchs programmés'**
  String get scheduledTitle;

  /// No description provided for @scheduledYouOrganize.
  ///
  /// In fr, this message translates to:
  /// **'vous organisez'**
  String get scheduledYouOrganize;

  /// No description provided for @settingsDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsDark;

  /// No description provided for @settingsGuide.
  ///
  /// In fr, this message translates to:
  /// **'Guide d’utilisation'**
  String get settingsGuide;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsLight;

  /// No description provided for @settingsSystem.
  ///
  /// In fr, this message translates to:
  /// **'Comme le téléphone'**
  String get settingsSystem;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @settingsVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @signInChangeNumber.
  ///
  /// In fr, this message translates to:
  /// **'Changer de numéro'**
  String get signInChangeNumber;

  /// No description provided for @signInCode.
  ///
  /// In fr, this message translates to:
  /// **'Code reçu'**
  String get signInCode;

  /// No description provided for @signInCodeSent.
  ///
  /// In fr, this message translates to:
  /// **'Code envoyé au {phone}'**
  String signInCodeSent(String phone);

  /// No description provided for @signInCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get signInCountry;

  /// No description provided for @signInPhone.
  ///
  /// In fr, this message translates to:
  /// **'Votre numéro de téléphone'**
  String get signInPhone;

  /// No description provided for @signInPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Votre numéro sert seulement à protéger votre compte. Les autres joueurs ne voient que votre pseudo.'**
  String get signInPrivacy;

  /// No description provided for @signInResend.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get signInResend;

  /// No description provided for @signInSendCode.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir le code par WhatsApp'**
  String get signInSendCode;

  /// No description provided for @signInTitle.
  ///
  /// In fr, this message translates to:
  /// **'Devenir joueur'**
  String get signInTitle;

  /// No description provided for @signInVerify.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get signInVerify;

  /// No description provided for @socialTitle.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs et groupes'**
  String get socialTitle;

  /// No description provided for @sourceAi.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get sourceAi;

  /// No description provided for @sourceManual.
  ///
  /// In fr, this message translates to:
  /// **'Écrite par vous'**
  String get sourceManual;

  /// No description provided for @sourceOffline.
  ///
  /// In fr, this message translates to:
  /// **'Tirée du texte'**
  String get sourceOffline;

  /// No description provided for @teamAccept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get teamAccept;

  /// No description provided for @teamAskJoin.
  ///
  /// In fr, this message translates to:
  /// **'Demander à entrer'**
  String get teamAskJoin;

  /// No description provided for @teamCaptain.
  ///
  /// In fr, this message translates to:
  /// **'capitaine'**
  String get teamCaptain;

  /// No description provided for @teamCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer une équipe'**
  String get teamCreate;

  /// No description provided for @teamDecline.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get teamDecline;

  /// No description provided for @teamInvitation.
  ///
  /// In fr, this message translates to:
  /// **'{captain} vous invite dans l’équipe « {team} »'**
  String teamInvitation(String captain, String team);

  /// No description provided for @teamInvite.
  ///
  /// In fr, this message translates to:
  /// **'Inviter un joueur'**
  String get teamInvite;

  /// No description provided for @teamInviteBusy.
  ///
  /// In fr, this message translates to:
  /// **'déjà en partie'**
  String get teamInviteBusy;

  /// No description provided for @teamInviteSearch.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo du joueur'**
  String get teamInviteSearch;

  /// No description provided for @teamInvited.
  ///
  /// In fr, this message translates to:
  /// **'invité'**
  String get teamInvited;

  /// No description provided for @teamLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter l’équipe'**
  String get teamLeave;

  /// No description provided for @teamName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l’équipe'**
  String get teamName;

  /// No description provided for @teamRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get teamRemove;

  /// No description provided for @teamRename.
  ///
  /// In fr, this message translates to:
  /// **'Renommer'**
  String get teamRename;

  /// No description provided for @teamRequested.
  ///
  /// In fr, this message translates to:
  /// **'demande à entrer'**
  String get teamRequested;

  /// No description provided for @teamSizeHint.
  ///
  /// In fr, this message translates to:
  /// **'De {min} à {max} joueurs par équipe.'**
  String teamSizeHint(int min, int max);

  /// No description provided for @textLarger.
  ///
  /// In fr, this message translates to:
  /// **'Texte plus grand'**
  String get textLarger;

  /// No description provided for @textSmaller.
  ///
  /// In fr, this message translates to:
  /// **'Texte plus petit'**
  String get textSmaller;

  /// No description provided for @tourAbandon.
  ///
  /// In fr, this message translates to:
  /// **'Abandonner le tournoi'**
  String get tourAbandon;

  /// No description provided for @tourAbandonBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre duel en cours ou à venir sera perdu.'**
  String get tourAbandonBody;

  /// No description provided for @tourAbandonTeamBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous quittez votre équipe ; elle continue sans vous.'**
  String get tourAbandonTeamBody;

  /// No description provided for @tourAgainst.
  ///
  /// In fr, this message translates to:
  /// **'Contre {name}'**
  String tourAgainst(String name);

  /// No description provided for @tourBracket.
  ///
  /// In fr, this message translates to:
  /// **'Tableau'**
  String get tourBracket;

  /// No description provided for @tourBye.
  ///
  /// In fr, this message translates to:
  /// **'Exempt'**
  String get tourBye;

  /// No description provided for @tourByeWin.
  ///
  /// In fr, this message translates to:
  /// **'Qualifié d’office'**
  String get tourByeWin;

  /// No description provided for @tourCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le tournoi'**
  String get tourCancel;

  /// No description provided for @tourCancelBody.
  ///
  /// In fr, this message translates to:
  /// **'Tous les participants seront prévenus. C’est définitif.'**
  String get tourCancelBody;

  /// No description provided for @tourCancelConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Annuler ce tournoi ?'**
  String get tourCancelConfirm;

  /// No description provided for @tourCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Ce tournoi a été annulé.'**
  String get tourCancelled;

  /// No description provided for @tourCode.
  ///
  /// In fr, this message translates to:
  /// **'Code du tournoi'**
  String get tourCode;

  /// No description provided for @tourCreateSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer le tournoi'**
  String get tourCreateSubmit;

  /// No description provided for @tourCreateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau tournoi'**
  String get tourCreateTitle;

  /// No description provided for @tourDeadlinePassed.
  ///
  /// In fr, this message translates to:
  /// **'Délai écoulé, résultat en cours…'**
  String get tourDeadlinePassed;

  /// No description provided for @tourDoubleForfeit.
  ///
  /// In fr, this message translates to:
  /// **'Double forfait'**
  String get tourDoubleForfeit;

  /// No description provided for @tourDuelLive.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get tourDuelLive;

  /// No description provided for @tourDuelPending.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get tourDuelPending;

  /// No description provided for @tourDuelPlaying.
  ///
  /// In fr, this message translates to:
  /// **'Votre duel est en cours'**
  String get tourDuelPlaying;

  /// No description provided for @tourDuelReadyWait.
  ///
  /// In fr, this message translates to:
  /// **'En attente des joueurs'**
  String get tourDuelReadyWait;

  /// No description provided for @tourEliminated.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes éliminé. Merci d’avoir joué !'**
  String get tourEliminated;

  /// No description provided for @tourEliminatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes éliminé au tour {round}. Merci d’avoir joué !'**
  String tourEliminatedAt(int round);

  /// No description provided for @tourEliminatedTag.
  ///
  /// In fr, this message translates to:
  /// **'éliminé'**
  String get tourEliminatedTag;

  /// No description provided for @tourEntriesRange.
  ///
  /// In fr, this message translates to:
  /// **'Participants : de {min} à {max}'**
  String tourEntriesRange(int min, int max);

  /// No description provided for @tourEntriesTeamHint.
  ///
  /// In fr, this message translates to:
  /// **'Une équipe compte pour un participant.'**
  String get tourEntriesTeamHint;

  /// No description provided for @tourFinal.
  ///
  /// In fr, this message translates to:
  /// **'Finale'**
  String get tourFinal;

  /// No description provided for @tourForfeitDelay.
  ///
  /// In fr, this message translates to:
  /// **'Délai pour confirmer « Prêt »'**
  String get tourForfeitDelay;

  /// No description provided for @tourForfeitHint.
  ///
  /// In fr, this message translates to:
  /// **'Quand un duel s’ouvre, chaque camp a ce délai pour se déclarer prêt. Sinon, il perd par forfait.'**
  String get tourForfeitHint;

  /// No description provided for @tourForfeitIn.
  ///
  /// In fr, this message translates to:
  /// **'Forfait dans {time}'**
  String tourForfeitIn(String time);

  /// No description provided for @tourForfeitResult.
  ///
  /// In fr, this message translates to:
  /// **'Forfait'**
  String get tourForfeitResult;

  /// No description provided for @tourFormat.
  ///
  /// In fr, this message translates to:
  /// **'Formule'**
  String get tourFormat;

  /// No description provided for @tourFull.
  ///
  /// In fr, this message translates to:
  /// **'Le tournoi est complet.'**
  String get tourFull;

  /// No description provided for @tourGroupField.
  ///
  /// In fr, this message translates to:
  /// **'Réservé à un groupe'**
  String get tourGroupField;

  /// No description provided for @tourGroupFieldHint.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les membres du groupe pourront s’inscrire.'**
  String get tourGroupFieldHint;

  /// No description provided for @tourGroupNone.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert à tous'**
  String get tourGroupNone;

  /// No description provided for @tourGroupOnly.
  ///
  /// In fr, this message translates to:
  /// **'Réservé aux membres du groupe « {name} »'**
  String tourGroupOnly(String name);

  /// No description provided for @tourHoursValue.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =0{0 heure} =1{1 heure} other{{n} heures}}'**
  String tourHoursValue(int n);

  /// No description provided for @tourJoinDuel.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre le duel'**
  String get tourJoinDuel;

  /// No description provided for @tourMinutesValue.
  ///
  /// In fr, this message translates to:
  /// **'{minutes, plural, =0{0 minute} =1{1 minute} other{{minutes} minutes}}'**
  String tourMinutesValue(int minutes);

  /// No description provided for @tourModeSolo.
  ///
  /// In fr, this message translates to:
  /// **'Entre joueurs'**
  String get tourModeSolo;

  /// No description provided for @tourModeSoloHint.
  ///
  /// In fr, this message translates to:
  /// **'Chaque joueur s’inscrit seul ; les duels opposent deux joueurs.'**
  String get tourModeSoloHint;

  /// No description provided for @tourModeTeam.
  ///
  /// In fr, this message translates to:
  /// **'Entre équipes'**
  String get tourModeTeam;

  /// No description provided for @tourModeTeamHint.
  ///
  /// In fr, this message translates to:
  /// **'Les joueurs forment des équipes ; les duels opposent deux équipes.'**
  String get tourModeTeamHint;

  /// No description provided for @tourName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du tournoi'**
  String get tourName;

  /// No description provided for @tourNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Par ex. : Tournoi des jeunes — Évangile de Jean'**
  String get tourNameHint;

  /// No description provided for @tourNameTooShort.
  ///
  /// In fr, this message translates to:
  /// **'3 caractères au moins'**
  String get tourNameTooShort;

  /// No description provided for @tourNeedEntries.
  ///
  /// In fr, this message translates to:
  /// **'Il faut au moins {min} participants pour lancer (inscrits : {count}).'**
  String tourNeedEntries(int min, int count);

  /// No description provided for @tourNeedPages.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez les pages au programme.'**
  String get tourNeedPages;

  /// No description provided for @tourNoEntries.
  ///
  /// In fr, this message translates to:
  /// **'Personne n’est encore inscrit. Partagez le code !'**
  String get tourNoEntries;

  /// No description provided for @tourNoWinner.
  ///
  /// In fr, this message translates to:
  /// **'Tournoi terminé sans vainqueur.'**
  String get tourNoWinner;

  /// No description provided for @tourOpponentReady.
  ///
  /// In fr, this message translates to:
  /// **'{name} est prêt'**
  String tourOpponentReady(String name);

  /// No description provided for @tourOpponentWaiting.
  ///
  /// In fr, this message translates to:
  /// **'{name} n’a pas encore confirmé'**
  String tourOpponentWaiting(String name);

  /// No description provided for @tourOrganize.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get tourOrganize;

  /// No description provided for @tourOrganizedBy.
  ///
  /// In fr, this message translates to:
  /// **'Organisé par {name}'**
  String tourOrganizedBy(String name);

  /// No description provided for @tourOrganizer.
  ///
  /// In fr, this message translates to:
  /// **'Organisateur'**
  String get tourOrganizer;

  /// No description provided for @tourPlay.
  ///
  /// In fr, this message translates to:
  /// **'Je joue aussi'**
  String get tourPlay;

  /// No description provided for @tourPlaySoloHint.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes inscrit d’office. Sinon, vous organisez seulement.'**
  String get tourPlaySoloHint;

  /// No description provided for @tourPlayTeamHint.
  ///
  /// In fr, this message translates to:
  /// **'Vous créez votre équipe et en êtes le capitaine.'**
  String get tourPlayTeamHint;

  /// No description provided for @tourPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs inscrits : {count}/{max}'**
  String tourPlayers(int count, int max);

  /// No description provided for @tourPublic.
  ///
  /// In fr, this message translates to:
  /// **'Visible dans les tournois ouverts'**
  String get tourPublic;

  /// No description provided for @tourPublicHint.
  ///
  /// In fr, this message translates to:
  /// **'Sinon, seuls ceux qui ont le code peuvent s’inscrire.'**
  String get tourPublicHint;

  /// No description provided for @tourQuarterFinals.
  ///
  /// In fr, this message translates to:
  /// **'Quarts de finale'**
  String get tourQuarterFinals;

  /// No description provided for @tourQuestionsPerDuel.
  ///
  /// In fr, this message translates to:
  /// **'Questions par duel : {n}'**
  String tourQuestionsPerDuel(int n);

  /// No description provided for @tourReady.
  ///
  /// In fr, this message translates to:
  /// **'Prêt !'**
  String get tourReady;

  /// No description provided for @tourReadyHint.
  ///
  /// In fr, this message translates to:
  /// **'Le duel commence dès que les deux camps sont prêts.'**
  String get tourReadyHint;

  /// No description provided for @tourRegister.
  ///
  /// In fr, this message translates to:
  /// **'M’inscrire'**
  String get tourRegister;

  /// No description provided for @tourRegistered.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes inscrit. Le tournoi commencera quand l’organisateur le lancera.'**
  String get tourRegistered;

  /// No description provided for @tourRound.
  ///
  /// In fr, this message translates to:
  /// **'Tour {round}'**
  String tourRound(int round);

  /// No description provided for @tourRoundDefault.
  ///
  /// In fr, this message translates to:
  /// **'Pages du tournoi'**
  String get tourRoundDefault;

  /// No description provided for @tourRoundPages.
  ///
  /// In fr, this message translates to:
  /// **'Pages par tour'**
  String get tourRoundPages;

  /// No description provided for @tourRoundPagesHint.
  ///
  /// In fr, this message translates to:
  /// **'Par défaut, chaque tour porte sur les pages du tournoi. Vous pouvez en choisir d’autres pour un tour (par exemple, la finale sur tout le programme).'**
  String get tourRoundPagesHint;

  /// No description provided for @tourRoundReset.
  ///
  /// In fr, this message translates to:
  /// **'Revenir aux pages du tournoi'**
  String get tourRoundReset;

  /// No description provided for @tourRoundStarted.
  ///
  /// In fr, this message translates to:
  /// **'Ce tour a commencé'**
  String get tourRoundStarted;

  /// No description provided for @tourRules.
  ///
  /// In fr, this message translates to:
  /// **'Règlement'**
  String get tourRules;

  /// No description provided for @tourRulesDuel.
  ///
  /// In fr, this message translates to:
  /// **'{n} questions par duel · {seconds} s par question'**
  String tourRulesDuel(int n, int seconds);

  /// No description provided for @tourRulesElimination.
  ///
  /// In fr, this message translates to:
  /// **'Élimination directe : le perdant de chaque duel est éliminé.'**
  String get tourRulesElimination;

  /// No description provided for @tourRulesEntries.
  ///
  /// In fr, this message translates to:
  /// **'De {min} à {max} participants'**
  String tourRulesEntries(int min, int max);

  /// No description provided for @tourRulesForfeit.
  ///
  /// In fr, this message translates to:
  /// **'« Prêt » à confirmer dans les {minutes} min, sinon forfait'**
  String tourRulesForfeit(int minutes);

  /// No description provided for @tourRulesHand.
  ///
  /// In fr, this message translates to:
  /// **'Après avoir pris la main : {seconds} s pour répondre'**
  String tourRulesHand(int seconds);

  /// No description provided for @tourSaved.
  ///
  /// In fr, this message translates to:
  /// **'Pages enregistrées'**
  String get tourSaved;

  /// No description provided for @tourSemiFinals.
  ///
  /// In fr, this message translates to:
  /// **'Demi-finales'**
  String get tourSemiFinals;

  /// No description provided for @tourShareText.
  ///
  /// In fr, this message translates to:
  /// **'Inscris-toi au tournoi « {name} » de Génie en herbe ({passages}) ! Code : {code}'**
  String tourShareText(String name, String passages, String code);

  /// No description provided for @tourSpectator.
  ///
  /// In fr, this message translates to:
  /// **'Vous suivez ce tournoi.'**
  String get tourSpectator;

  /// No description provided for @tourStart.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le tournoi'**
  String get tourStart;

  /// No description provided for @tourStartBody.
  ///
  /// In fr, this message translates to:
  /// **'Les inscriptions seront closes et le tableau tiré au sort.'**
  String get tourStartBody;

  /// No description provided for @tourStartBodyTeam.
  ///
  /// In fr, this message translates to:
  /// **'Les inscriptions seront closes et le tableau tiré au sort. Les équipes de moins de {min} joueurs ne seront pas retenues.'**
  String tourStartBodyTeam(int min);

  /// No description provided for @tourStartConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le tournoi ?'**
  String get tourStartConfirm;

  /// No description provided for @tourStateCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get tourStateCancelled;

  /// No description provided for @tourStateFinished.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get tourStateFinished;

  /// No description provided for @tourStateRegistration.
  ///
  /// In fr, this message translates to:
  /// **'Inscriptions ouvertes'**
  String get tourStateRegistration;

  /// No description provided for @tourStateRunning.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get tourStateRunning;

  /// No description provided for @tourTbd.
  ///
  /// In fr, this message translates to:
  /// **'À déterminer'**
  String get tourTbd;

  /// No description provided for @tourTeamHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre équipe et invitez vos coéquipiers, ou demandez à entrer dans une équipe ci-dessous.'**
  String get tourTeamHint;

  /// No description provided for @tourTeamIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Équipe incomplète : il faut {min} joueurs au moins, sinon elle ne sera pas retenue au lancement.'**
  String tourTeamIncomplete(int min);

  /// No description provided for @tourTeamReady.
  ///
  /// In fr, this message translates to:
  /// **'Votre équipe est prête'**
  String get tourTeamReady;

  /// No description provided for @tourTeams.
  ///
  /// In fr, this message translates to:
  /// **'Équipes inscrites : {count}/{max}'**
  String tourTeams(int count, int max);

  /// No description provided for @tourTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tournoi'**
  String get tourTitle;

  /// No description provided for @tourUnregister.
  ///
  /// In fr, this message translates to:
  /// **'Me désinscrire'**
  String get tourUnregister;

  /// No description provided for @tourUnregisterConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Vous désinscrire de ce tournoi ?'**
  String get tourUnregisterConfirm;

  /// No description provided for @tourWaitingNext.
  ///
  /// In fr, this message translates to:
  /// **'Qualifié ! En attente de votre prochain adversaire.'**
  String get tourWaitingNext;

  /// No description provided for @tourWinner.
  ///
  /// In fr, this message translates to:
  /// **'{name} remporte le tournoi !'**
  String tourWinner(String name);

  /// No description provided for @tourYou.
  ///
  /// In fr, this message translates to:
  /// **'vous'**
  String get tourYou;

  /// No description provided for @tourYouReady.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes prêt'**
  String get tourYouReady;

  /// No description provided for @tourYouWon.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez gagné le tournoi !'**
  String get tourYouWon;

  /// No description provided for @tourYourDuel.
  ///
  /// In fr, this message translates to:
  /// **'Votre duel'**
  String get tourYourDuel;

  /// No description provided for @unblock.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer'**
  String get unblock;

  /// No description provided for @updateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} disponible'**
  String updateAvailable(String version);

  /// No description provided for @updateDownload.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get updateDownload;

  /// No description provided for @updateLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get updateLater;

  /// No description provided for @updateRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour obligatoire : version {version}'**
  String updateRequired(String version);

  /// No description provided for @updateRequiredHint.
  ///
  /// In fr, this message translates to:
  /// **'Cette version n’est plus prise en charge : installez la nouvelle pour continuer.'**
  String get updateRequiredHint;

  /// No description provided for @webInstallAction.
  ///
  /// In fr, this message translates to:
  /// **'Installer'**
  String get webInstallAction;

  /// No description provided for @webInstallBody.
  ///
  /// In fr, this message translates to:
  /// **'Plus fluide au quotidien, et vos données ne dépendent plus du navigateur.'**
  String get webInstallBody;

  /// No description provided for @webInstallTitle.
  ///
  /// In fr, this message translates to:
  /// **'Installez l’application Android'**
  String get webInstallTitle;

  /// No description provided for @welcomeSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get welcomeSignIn;

  /// No description provided for @welcomeStep1.
  ///
  /// In fr, this message translates to:
  /// **'Chargez un document'**
  String get welcomeStep1;

  /// No description provided for @welcomeStep1Body.
  ///
  /// In fr, this message translates to:
  /// **'Un cours, un manuel, une présentation ou un tableau : PDF, Word, PowerPoint, Excel, OpenDocument, texte, ou des photos de pages.'**
  String get welcomeStep1Body;

  /// No description provided for @welcomeStep2.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez les pages'**
  String get welcomeStep2;

  /// No description provided for @welcomeStep2Body.
  ///
  /// In fr, this message translates to:
  /// **'Les pages au programme : les questions sont préparées pour elles, par l’IA ou tirées du texte.'**
  String get welcomeStep2Body;

  /// No description provided for @welcomeStep3.
  ///
  /// In fr, this message translates to:
  /// **'Jouez à plusieurs'**
  String get welcomeStep3;

  /// No description provided for @welcomeStep3Body.
  ///
  /// In fr, this message translates to:
  /// **'Matchs, équipes et tournois : le premier qui prend la main répond. Chaque réponse renvoie à la page.'**
  String get welcomeStep3Body;

  /// No description provided for @welcomeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Des concours de questions sur vos cours et vos documents.'**
  String get welcomeTagline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
