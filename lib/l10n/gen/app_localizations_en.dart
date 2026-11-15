// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aiCodeLabel => 'AI code (GH-XXXX-XXXX)';

  @override
  String aiCredits(int count) {
    return 'AI credits: $count';
  }

  @override
  String get aiExplain =>
      'A batch = a few pages (about 9,000 characters). Beyond the free quota, AI credits are used; without credits, questions are drawn from the text without AI.';

  @override
  String get aiFailures =>
      'AI failed several times today: questions are drawn from the text without AI.';

  @override
  String aiFreeToday(int left, int daily) {
    return 'Free today: $left batch(es) of $daily';
  }

  @override
  String get aiLanguage => 'AI does not handle this language.';

  @override
  String get aiOff => 'AI is not available on this server.';

  @override
  String get aiQueued =>
      'Questions without AI are ready. AI is preparing better questions: this screen updates by itself.';

  @override
  String get aiQueuedPartly =>
      'AI is preparing some of the pages; today’s quota is reached for the others (questions without AI).';

  @override
  String get aiQuota =>
      'Today’s AI quota is reached: questions are drawn from the text without AI. An AI code adds credits.';

  @override
  String get aiRedeem => 'Enter an AI code';

  @override
  String aiRedeemed(int count) {
    return '$count AI credit(s) added.';
  }

  @override
  String get aiTitle => 'Questions written by AI';

  @override
  String get aiUnavailable =>
      'AI unavailable for now: questions drawn from the text without AI.';

  @override
  String get appTitle => 'Génie en herbe';

  @override
  String get block => 'Block';

  @override
  String get blockHint =>
      'This player will no longer be able to invite you. They are not told.';

  @override
  String blockPlayer(String pseudo) {
    return 'Block $pseudo?';
  }

  @override
  String get blockedTitle => 'Blocked players';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get contactFavorite => 'Add to favourites';

  @override
  String contactMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches together',
      one: '1 match together',
      zero: 'no match together',
    );
    return '$_temp0';
  }

  @override
  String get contactUnfavorite => 'Remove from favourites';

  @override
  String get contactsEmpty =>
      'Players from your matches will appear here. Search a nickname to invite someone else.';

  @override
  String get contactsHint =>
      'People you played with, your favourites, who can invite you';

  @override
  String get contactsTitle => 'My players';

  @override
  String get copied => 'Copied';

  @override
  String get copy => 'Copy';

  @override
  String get createChangePages => 'Change the pages';

  @override
  String get createChoosePages => 'Choose the pages';

  @override
  String createHandTime(int seconds) {
    return 'Time to answer after grabbing the hand: $seconds s';
  }

  @override
  String get createHostOnly => 'Host without playing';

  @override
  String get createHostOnlyHint =>
      'You start and project the match; others play (a class, two teams…).';

  @override
  String get createMatchTitle => 'New match';

  @override
  String createMaxPlayers(int n) {
    return 'Players at most: $n';
  }

  @override
  String get createNoPages => 'No pages chosen.';

  @override
  String get createNotEnough =>
      'Not enough questions: add pages, or lower the number of questions.';

  @override
  String get createPages => 'Pages on the syllabus';

  @override
  String get createPublic => 'Listed in open matches';

  @override
  String get createPublicHint =>
      'Otherwise, only people with the code can join.';

  @override
  String createQuestionTime(int seconds) {
    return 'Time per question: $seconds s';
  }

  @override
  String createQuestions(int n) {
    return 'Questions: $n';
  }

  @override
  String get createSubmit => 'Create the match';

  @override
  String get createWaitQuestions =>
      'AI is still preparing questions: wait a little, or lower the number of questions.';

  @override
  String get docAddShared => 'Add a shared document';

  @override
  String docAdded(String name) {
    return '“$name” added to your documents.';
  }

  @override
  String docBy(String owner) {
    return 'by $owner';
  }

  @override
  String get docDelete => 'Delete the document';

  @override
  String get docDeleteConfirm =>
      'The document, its pages and its questions will be erased. Matches already played keep their questions.';

  @override
  String get docForget => 'Remove from my documents';

  @override
  String get docFrom => 'From';

  @override
  String get docImport => 'Upload a document';

  @override
  String get docJustImported =>
      'Document uploaded! Tick the pages on the syllabus, then “Prepare questions” or “Match”.';

  @override
  String get docMatch => 'Match';

  @override
  String get docNoPublic => 'No public documents yet.';

  @override
  String get docPractice => 'Practise';

  @override
  String get docPrepare => 'Prepare questions';

  @override
  String get docPrivate => 'Private';

  @override
  String get docPrivateHint => 'Only you can see it.';

  @override
  String get docPublic => 'Public';

  @override
  String get docPublicHint =>
      'All players find it among public documents. Its questions stay visible to you only.';

  @override
  String get docPublicLibrary => 'Public documents';

  @override
  String get docRename => 'Rename';

  @override
  String get docSearch => 'Search a title';

  @override
  String get docSelectAll => 'Select all';

  @override
  String get docSelectHint =>
      'Tick the pages on the syllabus to prepare their questions, create a match or a tournament, or practise.';

  @override
  String get docSelectNone => 'Clear';

  @override
  String get docSelectRange => 'Choose from… to…';

  @override
  String docSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages selected',
      one: '1 page selected',
      zero: 'no page selected',
    );
    return '$_temp0';
  }

  @override
  String get docShare => 'Share';

  @override
  String get docShareCode => 'Share code';

  @override
  String get docShareHint =>
      'In Génie en herbe: Documents → menu → Add a shared document, then type this code.';

  @override
  String docShareText(String name, String code) {
    return 'I am sharing the document “$name” on Génie en herbe. Code: $code';
  }

  @override
  String get docShared => 'Shared by code';

  @override
  String get docSharedHint =>
      'People with its code can add it, read it and play on it.';

  @override
  String get docTo => 'To';

  @override
  String get docTournament => 'Tournament';

  @override
  String docUnits(int count, String unit) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'slide': 'slides',
      'sheet': 'sheets',
      'part': 'parts',
      'other': 'pages',
    });
    String _temp1 = intl.Intl.selectLogic(unit, {
      'slide': 'slide',
      'sheet': 'sheet',
      'part': 'part',
      'other': 'page',
    });
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $_temp0',
      one: '1 $_temp1',
      zero: 'no pages',
    );
    return '$_temp2';
  }

  @override
  String get docVisibility => 'Visibility';

  @override
  String get editorAddOption => 'Add a choice';

  @override
  String get editorExplain => 'Explanation (optional)';

  @override
  String get editorNeedAnswer => 'Tick a filled-in choice as the right answer.';

  @override
  String get editorNeedOptions => 'At least two choices are needed.';

  @override
  String editorOption(int n) {
    return 'Choice $n';
  }

  @override
  String get editorOptionsHint => 'Tick the right answer.';

  @override
  String get editorPrompt => 'Question';

  @override
  String get editorPromptTooShort => 'The question is too short.';

  @override
  String get errBadCode => 'Wrong or expired code.';

  @override
  String get errBanned => 'Your player account is suspended.';

  @override
  String get errCorrupt => 'This file is unreadable or damaged.';

  @override
  String get errEmptyFile => 'This file contains no text.';

  @override
  String get errEncrypted => 'This file is password-protected.';

  @override
  String get errFull => 'It is full.';

  @override
  String get errHandTaken => 'Too late: another player grabbed the hand.';

  @override
  String get errHost => 'You host this match without playing.';

  @override
  String get errLegacyOffice =>
      'Old Office format (.doc, .ppt, .xls): save it as .docx, .pptx, .xlsx or PDF.';

  @override
  String get errLocked => 'You can no longer answer this question.';

  @override
  String get errNetwork => 'No Internet connection.';

  @override
  String get errNoHand => 'You no longer have the hand.';

  @override
  String get errNoText =>
      'No readable text: a scanned document must go through text recognition (photos of pages, on Android).';

  @override
  String get errPages => 'Choose valid pages.';

  @override
  String get errQuestions =>
      'These pages do not give enough questions: add pages, or lower the number of questions.';

  @override
  String get errQuestionsPending =>
      'Questions for these pages are being prepared: try again in a minute.';

  @override
  String get errRateLimited => 'Too many attempts. Try again in a few minutes.';

  @override
  String get errScanner =>
      'The document scanner is not available on this phone.';

  @override
  String get errServer =>
      'The server is not responding properly. Try again later.';

  @override
  String get errServerBusy =>
      'Too many games in progress right now. Try again in a few minutes.';

  @override
  String get errTooLarge => 'This file is too large (40 MB at most).';

  @override
  String get errTooLate => 'Time is up.';

  @override
  String get errUnknownCode => 'No match or tournament with this code.';

  @override
  String get errUnsupported => 'Unsupported format.';

  @override
  String get eventDuelReady => 'Tournament: your duel is waiting!';

  @override
  String eventGroupJoined(String pseudo, String name) {
    return '$pseudo joined the “$name” group';
  }

  @override
  String eventInvitation(String captain, String team) {
    return '$captain invites you to the “$team” team';
  }

  @override
  String eventRematch(String code) {
    return 'Rematch offered: code $code';
  }

  @override
  String eventRequest(String pseudo) {
    return '$pseudo asks to join your team';
  }

  @override
  String get eventSee => 'See';

  @override
  String eventTournamentInvitation(String who, String name) {
    return '$who invites you to the “$name” tournament';
  }

  @override
  String groupBy(String owner) {
    return 'created by $owner';
  }

  @override
  String get groupCode => 'Group code';

  @override
  String get groupCreate => 'Create a group';

  @override
  String get groupDelete => 'Delete the group';

  @override
  String get groupDeleteHint => 'The group disappears for all its members.';

  @override
  String get groupJoin => 'Join a group';

  @override
  String groupJoined(String name) {
    return 'You joined the “$name” group.';
  }

  @override
  String get groupLeave => 'Leave the group';

  @override
  String groupMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'no members',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersTitle => 'Members';

  @override
  String get groupMine => 'created by you';

  @override
  String get groupName => 'Group name';

  @override
  String get groupNotAGroup => 'This code is not a group code.';

  @override
  String get groupOwner => 'creator';

  @override
  String groupRemoveMember(String pseudo) {
    return 'Remove $pseudo from the group?';
  }

  @override
  String get groupRename => 'Rename the group';

  @override
  String get groupRenewCode => 'New code';

  @override
  String get groupRenewCodeHint =>
      'The old code will no longer let anyone join. Current members stay.';

  @override
  String get groupShareHint =>
      'In Génie en herbe: Play → Join, then type this code (or open the link).';

  @override
  String groupShareText(String name, String code) {
    return 'Join the “$name” group on Génie en herbe. Code: $code';
  }

  @override
  String groupTransfer(String pseudo) {
    return 'Hand the group over to $pseudo?';
  }

  @override
  String get groupTransferAction => 'Hand over the group';

  @override
  String get groupTransferHint =>
      'They will become the creator: only they will be able to manage the group.';

  @override
  String get groupsHint => 'A class, a club: invite the whole group at once';

  @override
  String get groupsIntro =>
      'Create a group (a class, a club) and share its code: everyone types it once. You can then invite the whole group to a match, or reserve a tournament for it.';

  @override
  String get groupsTitle => 'My groups';

  @override
  String get homeScreenBody =>
      'Tap Share (the square with an arrow), then “Add to Home Screen”. The app will open full screen and your data will be kept more reliably.';

  @override
  String get homeScreenDismiss => 'Got it';

  @override
  String get homeScreenTitle => 'Add the app to your Home Screen';

  @override
  String get importBlankPage => '(page without text)';

  @override
  String importChars(int count) {
    return '$count characters';
  }

  @override
  String get importDocTitle => 'Document title';

  @override
  String get importDuplicate =>
      'You had already uploaded this document: here it is.';

  @override
  String importEmptyPages(int count) {
    return '$count page(s) without text (blank pages, images)';
  }

  @override
  String get importFile => 'Choose a file';

  @override
  String get importFileHint =>
      'PDF, Word, PowerPoint, Excel, OpenDocument, EPUB, text, HTML, RTF';

  @override
  String get importIntro =>
      'The text is read on your phone, page by page, then sent to the server. The file itself never leaves the phone.';

  @override
  String get importLang => 'Document language';

  @override
  String get importLangAuto => 'Detected automatically';

  @override
  String get importLangHint => 'Questions are written in this language.';

  @override
  String importMorePages(int count) {
    return '… and $count more';
  }

  @override
  String get importNeedTitle => 'Give the document a title.';

  @override
  String get importOther => 'Choose another document';

  @override
  String get importPartsHint =>
      'This document has no pages: it is split into parts.';

  @override
  String get importPaste => 'Paste a text';

  @override
  String get importPasteHint => 'Paste the lesson’s text here…';

  @override
  String get importPasteSub => 'Split into parts of about 3,000 characters.';

  @override
  String get importPrivacy =>
      'Documents are private by default. You can share them by a code, or make them public.';

  @override
  String get importReading => 'Reading the file…';

  @override
  String importReadingPages(int done, int total) {
    return 'Reading pages: $done / $total';
  }

  @override
  String importRecognizing(int done, int total) {
    return 'Recognising text: $done / $total';
  }

  @override
  String get importScan => 'Photograph pages';

  @override
  String get importScanHint =>
      'A textbook or a notebook: one photo per page, the text is recognised on the phone.';

  @override
  String get importScanTitle => 'Photographed pages';

  @override
  String get importSend => 'Send';

  @override
  String get importSending => 'Sending the document…';

  @override
  String importSendingPages(int done, int total) {
    return 'Sending: $done / $total pages';
  }

  @override
  String get importTitle => 'Upload a document';

  @override
  String inviteBusy(String names) {
    return 'already in a game: $names';
  }

  @override
  String get inviteButton => 'Invite players';

  @override
  String get inviteDeclined => 'declined';

  @override
  String get inviteGroup => 'Invite the group';

  @override
  String get inviteNone => 'No invitation sent';

  @override
  String get invitePending => 'invited';

  @override
  String invitePlayersIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players already in the room',
      one: '1 player already in the room',
      zero: 'nobody in the room yet',
    );
    return '$_temp0';
  }

  @override
  String get invitePolicyAll => 'From everyone';

  @override
  String get invitePolicyKnown => 'From my players and groups only';

  @override
  String get invitePolicyNone => 'From no one';

  @override
  String get invitePolicyTitle => 'Receive invitations';

  @override
  String inviteReceived(String who) {
    return '$who invites you to a match';
  }

  @override
  String inviteSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invite $count players',
      one: 'Invite 1 player',
      zero: 'Invite',
    );
    return '$_temp0';
  }

  @override
  String inviteSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players invited',
      one: '1 player invited',
      zero: 'No player invited',
    );
    return '$_temp0';
  }

  @override
  String inviteSkipAlready(int count) {
    return '$count already here or already invited';
  }

  @override
  String inviteSkipGroup(int count) {
    return '$count outside the tournament’s group';
  }

  @override
  String get inviteSkipLimit => 'invitation limit reached for this hour';

  @override
  String inviteSkipRefused(int count) {
    return '$count do(es) not accept invitations';
  }

  @override
  String get libraryEmptyBody =>
      'Upload a lesson or a textbook with “Upload a document”, add a shared document by its code, or browse public documents.';

  @override
  String get libraryEmptyTitle => 'Your library is empty';

  @override
  String get libraryMine => 'My documents';

  @override
  String get libraryShared => 'Shared with me';

  @override
  String get libraryTitle => 'My documents';

  @override
  String get loadError => 'The content could not be loaded.';

  @override
  String get lobbyCancelled => 'This match was cancelled.';

  @override
  String get lobbyCode => 'Match code';

  @override
  String get lobbyCreator => 'creator';

  @override
  String lobbyHostedBy(String pseudo) {
    return 'Hosted by $pseudo, who does not play';
  }

  @override
  String get lobbyKick => 'Remove from the match';

  @override
  String get lobbyLeave => 'Leave';

  @override
  String get lobbyLeaveConfirm => 'Leave this match?';

  @override
  String get lobbyLeaveRunning =>
      'Leaving a match in progress means giving up.';

  @override
  String get lobbyNeedPlayers => 'At least 2 players are needed.';

  @override
  String get lobbyNoTeam => 'Without a team';

  @override
  String get lobbyNoTeamHint =>
      'Players without a team do not play: ask to join a team, or create one.';

  @override
  String get lobbyPlayers => 'Players';

  @override
  String get lobbyRevise => 'Revise the pages';

  @override
  String lobbySettings(int n, int seconds, String hand) {
    return '$n questions · $seconds s per question · hand: $hand s';
  }

  @override
  String get lobbyShareHint =>
      'Other players type this code under Play → Join, or scan the QR code with their camera.';

  @override
  String lobbyShareText(String passages, String code, String link) {
    return 'Join me for a Génie en herbe match ($passages)! Code: $code $link';
  }

  @override
  String get lobbyShareWhatsApp => 'Invite via WhatsApp';

  @override
  String get lobbyStart => 'Start the match';

  @override
  String get lobbyTitle => 'Waiting room';

  @override
  String lobbyWaitCreator(String name) {
    return 'Waiting for $name to start…';
  }

  @override
  String get navDocuments => 'Documents';

  @override
  String get navPlay => 'Play';

  @override
  String get navProfile => 'Profile';

  @override
  String get offlineHint =>
      'Pages you have already read stay available here: read them again and practise.';

  @override
  String get offlineNoPages =>
      'No pages kept on this device yet: open some pages once while online.';

  @override
  String get offlineTitle => 'No connection';

  @override
  String get onlineAccountHint =>
      'You need a phone number (code sent by WhatsApp) and a nickname.';

  @override
  String get onlineBecomePlayer => 'Become a player';

  @override
  String onlineBy(String name) {
    return 'by $name';
  }

  @override
  String get onlineCreateMatch => 'Create a match';

  @override
  String get onlineCreateTournament => 'Create a tournament';

  @override
  String get onlineCurrentMatch => 'You have a match in progress';

  @override
  String onlineCurrentTournament(String name) {
    return 'You are in the “$name” tournament';
  }

  @override
  String get onlineHistory => 'My matches';

  @override
  String get onlineIntro =>
      'Take on other players, alone or in a team, on the pages of your documents. The first to grab the hand answers; a right answer earns 10 points, a wrong one costs 5.';

  @override
  String get onlineInvitations => 'Invitations';

  @override
  String get onlineJoin => 'Join';

  @override
  String get onlineJoinHint => '6-character code';

  @override
  String get onlineJoinTitle => 'Join with a code';

  @override
  String get onlineModeSolo => 'Individual';

  @override
  String get onlineModeTeam => 'Teams';

  @override
  String get onlineMyTournaments => 'My tournaments';

  @override
  String get onlineNoHistory => 'Your finished matches will show here.';

  @override
  String get onlineNoOpenMatch =>
      'No open match right now. Create one and share its code.';

  @override
  String get onlineOpenMatches => 'Open matches';

  @override
  String get onlineOpenTournaments => 'Open tournaments';

  @override
  String get onlineOptional =>
      'An account is needed to upload documents and play.';

  @override
  String onlinePlayers(int players, int max) {
    return '$players/$max players';
  }

  @override
  String get onlineProjection => 'Projection screen';

  @override
  String get onlineProjectionHint =>
      'Show a match on a big screen (projector, TV), no account needed.';

  @override
  String get onlineRealtimeOff =>
      'Slow connection: the display may lag a little.';

  @override
  String get onlineResume => 'Resume';

  @override
  String onlineStats(int played, int won) {
    String _temp0 = intl.Intl.pluralLogic(
      played,
      locale: localeName,
      other: '$played matches',
      one: '1 match',
      zero: 'No match',
    );
    String _temp1 = intl.Intl.pluralLogic(
      won,
      locale: localeName,
      other: '$won won',
      one: '1 won',
      zero: 'none won',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get onlineTitle => 'Play';

  @override
  String get pageAiDone => 'AI ✓';

  @override
  String get pageAiFailed => 'AI unavailable';

  @override
  String get pageAiRunning => 'AI working…';

  @override
  String get pageEmpty => 'Page without text';

  @override
  String get pageNext => 'Next page';

  @override
  String get pageOfflineCopy => 'Copy kept on this device (no network).';

  @override
  String get pagePrevious => 'Previous page';

  @override
  String get pageRead => 'Read the page';

  @override
  String pageValidated(int count) {
    return '$count validated';
  }

  @override
  String pagesAiPending(int ready, int pages) {
    return '$ready question(s) ready; AI is still preparing $pages page(s)…';
  }

  @override
  String get pagesClear => 'Remove these pages';

  @override
  String pagesReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions ready',
      one: '1 question ready',
      zero: 'no question ready',
    );
    return '$_temp0';
  }

  @override
  String pickerConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirm $count pages',
      one: 'Confirm 1 page',
      zero: 'Confirm',
    );
    return '$_temp0';
  }

  @override
  String get pickerHint =>
      'Choose a document, then tick its pages. Their questions are prepared right away.';

  @override
  String get pickerTitle => 'Choose the pages';

  @override
  String playAnswerWas(String answer) {
    return 'Answer: $answer';
  }

  @override
  String playAnsweredWrong(String name) {
    return '$name was wrong: −5';
  }

  @override
  String get playBuzz => 'I’ll answer!';

  @override
  String get playCountdown => 'Ready?';

  @override
  String get playFromText => 'From the text';

  @override
  String playHandLost(String name) {
    return '$name let the hand go: −5';
  }

  @override
  String playHandOf(String name) {
    return '$name has the hand';
  }

  @override
  String get playLeft => 'left';

  @override
  String get playLocked => 'You can no longer answer this question';

  @override
  String get playLockedTeam => 'Your team can no longer answer this question';

  @override
  String get playNobody => 'Nobody got it';

  @override
  String get playPaused => 'Timer paused';

  @override
  String playPoints(int points) {
    return '$points pts';
  }

  @override
  String playQuestion(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String get playScores => 'Scores';

  @override
  String get playSpectator => 'You are watching this match';

  @override
  String get playTiebreak => 'Tiebreaker: the first right answer wins';

  @override
  String playWonBy(String name) {
    return '$name got it';
  }

  @override
  String get playYourHand => 'Your turn! Pick the answer';

  @override
  String get practiceAgain => 'More questions';

  @override
  String get practiceFalse => 'False';

  @override
  String get practiceFinish => 'See the result';

  @override
  String get practiceLanguage =>
      'Practice on the phone can only make questions in French and English.';

  @override
  String get practiceNext => 'Next question';

  @override
  String get practiceNoPages =>
      'These pages are not available offline: open them once while online.';

  @override
  String get practiceRight => 'Right!';

  @override
  String practiceScore(int score, int total) {
    return '$score right answer(s) out of $total';
  }

  @override
  String get practiceThesePages => 'Practise on these pages';

  @override
  String get practiceThisPage => 'Practise on this page';

  @override
  String get practiceTitle => 'Practice';

  @override
  String get practiceTooShort =>
      'These pages are too short for practice: choose more.';

  @override
  String get practiceTrue => 'True';

  @override
  String get practiceWrong => 'Not quite.';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileDelete => 'Delete my player account';

  @override
  String get profileDeleteConfirm =>
      'Your nickname, history and documents will be erased, and you will leave the current game.';

  @override
  String get profileDeleted => 'Player account deleted';

  @override
  String get profileRename => 'Change nickname';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileTournamentsWon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournaments won',
      one: '1 tournament won',
      zero: 'No tournament won',
    );
    return '$_temp0';
  }

  @override
  String get projectionCodePrompt => 'Code of the match to show';

  @override
  String get projectionShow => 'Show';

  @override
  String projectionWaiting(String code) {
    return 'Waiting for players — code $code';
  }

  @override
  String get pseudoHint => '3 to 20 characters, visible to other players';

  @override
  String get pseudoLabel => 'Nickname';

  @override
  String get pseudoSave => 'Let’s go';

  @override
  String get pseudoTitle => 'Choose your nickname';

  @override
  String questionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: 'no questions',
    );
    return '$_temp0';
  }

  @override
  String get questionsPrepared => 'Questions ready.';

  @override
  String get report => 'Report this nickname';

  @override
  String get reportReason => 'Why? (optional)';

  @override
  String get reportSent => 'Report sent. Thank you.';

  @override
  String get resultAbandon => 'Match stopped: one side left the game.';

  @override
  String get resultBack => 'Back';

  @override
  String get resultDraw => 'Draw';

  @override
  String get resultFirst => '#1';

  @override
  String get resultIdle => 'Match closed for lack of activity.';

  @override
  String resultRank(int rank) {
    return '#$rank';
  }

  @override
  String get resultReadPage => 'Read the page again';

  @override
  String get resultRematch => 'Rematch';

  @override
  String get resultRematchSent =>
      'New match created: the other players get the code.';

  @override
  String get resultReview => 'Review the questions';

  @override
  String get resultTiebreak => 'Decided by a tiebreaker.';

  @override
  String get resultTiebreakRule =>
      'Perfect tie: decided by the rules (fewer mistakes, then speed).';

  @override
  String get resultTitle => 'Results';

  @override
  String resultWinner(String name) {
    return '$name wins!';
  }

  @override
  String get resultYouWin => 'You won!';

  @override
  String get retry => 'Try again';

  @override
  String get reviewAdd => 'Add a question';

  @override
  String get reviewDelete => 'Delete the question';

  @override
  String get reviewEdit => 'Edit';

  @override
  String get reviewHint => 'Validated questions come first in matches.';

  @override
  String get reviewNone => 'No question for this page yet.';

  @override
  String reviewPlayed(int count) {
    return 'asked $count times';
  }

  @override
  String get reviewProposed => 'To review';

  @override
  String get reviewRegenerate => 'Regenerate';

  @override
  String get reviewRegenerateAi => 'Regenerate with AI';

  @override
  String get reviewRegenerateHint =>
      'This page’s non-validated questions are replaced by new ones.';

  @override
  String get reviewRegenerateOffline => 'Regenerate without AI';

  @override
  String get reviewTitle => 'Review questions';

  @override
  String get reviewValidateAll => 'Validate all';

  @override
  String get reviewValidated => 'Validated';

  @override
  String get save => 'Save';

  @override
  String get scanCameraDenied =>
      'Camera access was denied. Allow it in the phone settings, or type the code.';

  @override
  String get scanCameraUnavailable =>
      'The camera is not available. Type the game code.';

  @override
  String get scanFromImage => 'Choose an image';

  @override
  String get scanHint =>
      'Point at the QR code shown in the match or tournament waiting room.';

  @override
  String get scanNoQrInImage => 'No game QR code in this image.';

  @override
  String get scanNotAGame => 'This QR code is not a Génie en herbe game.';

  @override
  String get scanQr => 'Scan the QR code';

  @override
  String get scanTorch => 'Flashlight';

  @override
  String get scanTypeCode => 'Type the code';

  @override
  String get settingsDark => 'Dark';

  @override
  String get settingsGuide => 'User guide';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsSystem => 'Same as the phone';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsTitle => 'Settings';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get share => 'Share';

  @override
  String get signInChangeNumber => 'Change number';

  @override
  String get signInCode => 'Code received';

  @override
  String signInCodeSent(String phone) {
    return 'Code sent to $phone';
  }

  @override
  String get signInCountry => 'Country';

  @override
  String get signInPhone => 'Your phone number';

  @override
  String get signInPrivacy =>
      'Your number only protects your account. Other players only see your nickname.';

  @override
  String get signInResend => 'Send the code again';

  @override
  String get signInSendCode => 'Get the code on WhatsApp';

  @override
  String get signInTitle => 'Become a player';

  @override
  String get signInVerify => 'Confirm';

  @override
  String get socialTitle => 'Players and groups';

  @override
  String get sourceAi => 'AI';

  @override
  String get sourceManual => 'Written by you';

  @override
  String get sourceOffline => 'From the text';

  @override
  String get teamAccept => 'Accept';

  @override
  String get teamAskJoin => 'Ask to join';

  @override
  String get teamCaptain => 'captain';

  @override
  String get teamCreate => 'Create a team';

  @override
  String get teamDecline => 'Decline';

  @override
  String teamInvitation(String captain, String team) {
    return '$captain invites you to the “$team” team';
  }

  @override
  String get teamInvite => 'Invite a player';

  @override
  String get teamInviteBusy => 'already playing';

  @override
  String get teamInviteSearch => 'Player’s nickname';

  @override
  String get teamInvited => 'invited';

  @override
  String get teamLeave => 'Leave the team';

  @override
  String get teamName => 'Team name';

  @override
  String get teamRemove => 'Remove';

  @override
  String get teamRename => 'Rename';

  @override
  String get teamRequested => 'asks to join';

  @override
  String teamSizeHint(int min, int max) {
    return '$min to $max players per team.';
  }

  @override
  String get textLarger => 'Larger text';

  @override
  String get textSmaller => 'Smaller text';

  @override
  String get tourAbandon => 'Leave the tournament';

  @override
  String get tourAbandonBody => 'Your current or next duel will be lost.';

  @override
  String get tourAbandonTeamBody =>
      'You leave your team; it carries on without you.';

  @override
  String tourAgainst(String name) {
    return 'Against $name';
  }

  @override
  String get tourBracket => 'Bracket';

  @override
  String get tourBye => 'Bye';

  @override
  String get tourByeWin => 'Advances on a bye';

  @override
  String get tourCancel => 'Cancel the tournament';

  @override
  String get tourCancelBody =>
      'All participants will be notified. This cannot be undone.';

  @override
  String get tourCancelConfirm => 'Cancel this tournament?';

  @override
  String get tourCancelled => 'This tournament was cancelled.';

  @override
  String get tourCode => 'Tournament code';

  @override
  String get tourCreateSubmit => 'Create the tournament';

  @override
  String get tourCreateTitle => 'New tournament';

  @override
  String get tourDeadlinePassed => 'Time is up, settling the result…';

  @override
  String get tourDoubleForfeit => 'Double forfeit';

  @override
  String get tourDuelLive => 'Live';

  @override
  String get tourDuelPending => 'Upcoming';

  @override
  String get tourDuelPlaying => 'Your duel is in progress';

  @override
  String get tourDuelReadyWait => 'Waiting for players';

  @override
  String get tourEliminated => 'You are knocked out. Thanks for playing!';

  @override
  String tourEliminatedAt(int round) {
    return 'You were knocked out in round $round. Thanks for playing!';
  }

  @override
  String get tourEliminatedTag => 'out';

  @override
  String tourEntriesRange(int min, int max) {
    return 'Participants: $min to $max';
  }

  @override
  String get tourEntriesTeamHint => 'A team counts as one participant.';

  @override
  String get tourFinal => 'Final';

  @override
  String get tourForfeitDelay => 'Time to confirm “Ready”';

  @override
  String get tourForfeitHint =>
      'When a duel opens, each side has this long to say it is ready. Otherwise it loses by forfeit.';

  @override
  String tourForfeitIn(String time) {
    return 'Forfeit in $time';
  }

  @override
  String get tourForfeitResult => 'Forfeit';

  @override
  String get tourFormat => 'Format';

  @override
  String get tourFull => 'The tournament is full.';

  @override
  String get tourGroupField => 'Restricted to a group';

  @override
  String get tourGroupFieldHint =>
      'Only the group’s members will be able to register.';

  @override
  String get tourGroupNone => 'Open to everyone';

  @override
  String tourGroupOnly(String name) {
    return 'Restricted to members of the “$name” group';
  }

  @override
  String tourHoursValue(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get tourJoinDuel => 'Join the duel';

  @override
  String tourMinutesValue(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get tourModeSolo => 'Players';

  @override
  String get tourModeSoloHint =>
      'Each player registers alone; duels pit two players against each other.';

  @override
  String get tourModeTeam => 'Teams';

  @override
  String get tourModeTeamHint =>
      'Players form teams; duels pit two teams against each other.';

  @override
  String get tourName => 'Tournament name';

  @override
  String get tourNameHint => 'E.g. Youth tournament — Gospel of John';

  @override
  String get tourNameTooShort => 'At least 3 characters';

  @override
  String tourNeedEntries(int min, int count) {
    return 'At least $min participants are needed to start (registered: $count).';
  }

  @override
  String get tourNeedPages => 'Choose the pages on the syllabus.';

  @override
  String get tourNoEntries => 'Nobody has registered yet. Share the code!';

  @override
  String get tourNoWinner => 'Tournament ended without a winner.';

  @override
  String tourOpponentReady(String name) {
    return '$name is ready';
  }

  @override
  String tourOpponentWaiting(String name) {
    return '$name has not confirmed yet';
  }

  @override
  String get tourOrganize => 'Organization';

  @override
  String tourOrganizedBy(String name) {
    return 'Organized by $name';
  }

  @override
  String get tourOrganizer => 'Organizer';

  @override
  String get tourPlay => 'I play too';

  @override
  String get tourPlaySoloHint =>
      'You are registered right away. Otherwise, you only organize.';

  @override
  String get tourPlayTeamHint => 'You create your team and are its captain.';

  @override
  String tourPlayers(int count, int max) {
    return 'Registered players: $count/$max';
  }

  @override
  String get tourPublic => 'Listed in open tournaments';

  @override
  String get tourPublicHint =>
      'Otherwise, only people with the code can register.';

  @override
  String get tourQuarterFinals => 'Quarter-finals';

  @override
  String tourQuestionsPerDuel(int n) {
    return 'Questions per duel: $n';
  }

  @override
  String get tourReady => 'Ready!';

  @override
  String get tourReadyHint =>
      'The duel starts as soon as both sides are ready.';

  @override
  String get tourRegister => 'Register';

  @override
  String get tourRegistered =>
      'You are registered. The tournament starts when the organizer launches it.';

  @override
  String tourRound(int round) {
    return 'Round $round';
  }

  @override
  String get tourRoundDefault => 'Tournament pages';

  @override
  String get tourRoundPages => 'Pages per round';

  @override
  String get tourRoundPagesHint =>
      'By default, each round is on the tournament’s pages. You can choose others for a round (for example, the final on the whole syllabus).';

  @override
  String get tourRoundReset => 'Back to the tournament pages';

  @override
  String get tourRoundStarted => 'This round has started';

  @override
  String get tourRules => 'Rules';

  @override
  String tourRulesDuel(int n, int seconds) {
    return '$n questions per duel · $seconds s per question';
  }

  @override
  String get tourRulesElimination =>
      'Single elimination: the loser of each duel is out.';

  @override
  String tourRulesEntries(int min, int max) {
    return '$min to $max participants';
  }

  @override
  String tourRulesForfeit(int minutes) {
    return 'Confirm “Ready” within $minutes min, or forfeit';
  }

  @override
  String tourRulesHand(int seconds) {
    return 'After grabbing the hand: $seconds s to answer';
  }

  @override
  String get tourSaved => 'Pages saved';

  @override
  String get tourSemiFinals => 'Semi-finals';

  @override
  String tourShareText(String name, String passages, String code) {
    return 'Sign up for the “$name” Génie en herbe tournament ($passages)! Code: $code';
  }

  @override
  String get tourSpectator => 'You are following this tournament.';

  @override
  String get tourStart => 'Start the tournament';

  @override
  String get tourStartBody =>
      'Registration will close and the bracket will be drawn.';

  @override
  String tourStartBodyTeam(int min) {
    return 'Registration will close and the bracket will be drawn. Teams with fewer than $min players will be left out.';
  }

  @override
  String get tourStartConfirm => 'Start the tournament?';

  @override
  String get tourStateCancelled => 'Cancelled';

  @override
  String get tourStateFinished => 'Finished';

  @override
  String get tourStateRegistration => 'Registration open';

  @override
  String get tourStateRunning => 'In progress';

  @override
  String get tourTbd => 'To be decided';

  @override
  String get tourTeamHint =>
      'Create your team and invite teammates, or ask to join a team below.';

  @override
  String tourTeamIncomplete(int min) {
    return 'Incomplete team: it needs at least $min players, or it will be left out at the start.';
  }

  @override
  String get tourTeamReady => 'Your team is ready';

  @override
  String tourTeams(int count, int max) {
    return 'Registered teams: $count/$max';
  }

  @override
  String get tourTitle => 'Tournament';

  @override
  String get tourUnregister => 'Withdraw';

  @override
  String get tourUnregisterConfirm => 'Withdraw from this tournament?';

  @override
  String get tourWaitingNext => 'Through! Waiting for your next opponent.';

  @override
  String tourWinner(String name) {
    return '$name wins the tournament!';
  }

  @override
  String get tourYou => 'you';

  @override
  String get tourYouReady => 'You are ready';

  @override
  String get tourYouWon => 'You won the tournament!';

  @override
  String get tourYourDuel => 'Your duel';

  @override
  String get unblock => 'Unblock';

  @override
  String updateAvailable(String version) {
    return 'Version $version available';
  }

  @override
  String get updateDownload => 'Download';

  @override
  String get updateLater => 'Later';

  @override
  String updateRequired(String version) {
    return 'Update required: version $version';
  }

  @override
  String get updateRequiredHint =>
      'This version is no longer supported: install the new one to continue.';

  @override
  String get webInstallAction => 'Install';

  @override
  String get webInstallBody =>
      'Smoother every day, and your data no longer depends on the browser.';

  @override
  String get webInstallTitle => 'Install the Android app';

  @override
  String get welcomeSignIn => 'Sign in';

  @override
  String get welcomeStep1 => 'Upload a document';

  @override
  String get welcomeStep1Body =>
      'A lesson, a textbook, a presentation or a spreadsheet: PDF, Word, PowerPoint, Excel, OpenDocument, text, or photos of pages.';

  @override
  String get welcomeStep2 => 'Choose the pages';

  @override
  String get welcomeStep2Body =>
      'The pages on the syllabus: questions are prepared for them, by AI or drawn from the text.';

  @override
  String get welcomeStep3 => 'Play together';

  @override
  String get welcomeStep3Body =>
      'Matches, teams and tournaments: the first to grab the hand answers. Every answer points back to the page.';

  @override
  String get welcomeTagline =>
      'Quiz competitions on your lessons and documents.';
}
