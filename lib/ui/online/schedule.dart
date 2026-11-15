import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common.dart';

/// Date d'un match programmé, dans la langue de l'application et l'heure du téléphone :
/// « aujourd'hui à 14:30 », « demain à 9:00 », « samedi 21 novembre à 15:00 ».
String formatSchedule(BuildContext context, DateTime at) {
  final l = context.l10n;
  final local = at.toLocal();
  final locale = Localizations.localeOf(context).toLanguageTag();
  final time = DateFormat.Hm(locale).format(local);
  final now = DateTime.now();
  final day = DateTime(local.year, local.month, local.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = day.difference(today).inDays;
  if (diff == 0) return l.scheduleToday(time);
  if (diff == 1) return l.scheduleTomorrow(time);
  return l.scheduleOn(DateFormat.MMMMEEEEd(locale).format(local), time);
}

/// « dans 2 h 15 min » / « dans 3 jours » (vide si l'heure est passée).
String scheduleCountdown(BuildContext context, DateTime at) {
  final l = context.l10n;
  final d = at.difference(DateTime.now());
  if (d.isNegative) return '';
  if (d.inDays >= 1) return l.scheduleInDays(d.inDays);
  if (d.inHours >= 1) return l.scheduleInHours(d.inHours, d.inMinutes % 60);
  return l.scheduleInMinutes(d.inMinutes < 1 ? 1 : d.inMinutes);
}

/// Choisir la date puis l'heure d'un match (de 5 minutes à 30 jours à l'avance). Null si annulé.
Future<DateTime?> pickSchedule(BuildContext context, {DateTime? initial}) async {
  final now = DateTime.now();
  final start = initial ?? now.add(const Duration(hours: 1));
  final date = await showDatePicker(
    context: context,
    initialDate: start.isBefore(now) ? now : start,
    firstDate: DateTime(now.year, now.month, now.day),
    lastDate: now.add(const Duration(days: 30)),
    helpText: context.l10n.scheduleDate,
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(start),
    helpText: context.l10n.scheduleTime,
  );
  if (time == null || !context.mounted) return null;
  final picked = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  if (picked.isBefore(now.add(const Duration(minutes: 5)))) {
    context.toast(context.l10n.scheduleTooSoon);
    return null;
  }
  return picked;
}
