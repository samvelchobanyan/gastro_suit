import 'package:flutter/widgets.dart';

import '../../core/network/app_exception.dart';
import '../../l10n/generated/app_localizations.dart';

/// One sentence about a failed action: the server's own when there is one
/// (it is already in the user's language), otherwise ours.
String errorText(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context);
  if (error is AppException) {
    if (error.message case final message?) return message;
    if (error.kind == AppExceptionKind.noConnection) {
      return l10n.errorNoConnection;
    }
  }
  return l10n.errorGeneric;
}
