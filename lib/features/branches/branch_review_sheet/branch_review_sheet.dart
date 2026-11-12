import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/components/buttons/ds_button.dart';
import '../../../design_system/components/feedback/ds_skeleton.dart';
import '../../../design_system/components/inputs/ds_rating_input.dart';
import '../../../design_system/components/inputs/ds_text_area.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/branch_review.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../shared_widgets/error_text.dart';
import '../../shared_widgets/load_error_row.dart';
import 'branch_review_controller.dart';

/// Opens the sheet where the signed-in user rates the branch [branchId].
Future<void> showBranchReview(BuildContext context, String branchId) =>
    showDSBottomSheet<void>(
      context: context,
      title: AppLocalizations.of(context).leaveFeedback,
      child: BranchReviewSheet(branchId: branchId),
    );

/// Rates a branch: stars, optional words and "Send" (handoff
/// `FeedbackBottomSheet`).
///
/// Opens on the rating the user gave earlier, when there is one; sending
/// replaces it. The sheet closes once the rating is accepted. A rating that
/// was not accepted leaves the sheet open with what was entered and says
/// why.
class BranchReviewSheet extends ConsumerStatefulWidget {
  const BranchReviewSheet({super.key, required this.branchId});

  final String branchId;

  /// The API's limit for the words.
  static const _maxTextLength = 1000;

  @override
  ConsumerState<BranchReviewSheet> createState() => _BranchReviewSheetState();
}

class _BranchReviewSheetState extends ConsumerState<BranchReviewSheet> {
  final _text = TextEditingController();

  /// Zero until a star is chosen.
  int _rating = 0;
  bool _sending = false;

  /// Why the last send failed; null before one and while one runs.
  Object? _sendError;

  /// The earlier rating is put into the form once, not over the user's
  /// edits.
  bool _filled = false;

  @override
  void initState() {
    super.initState();
    final provider = branchReviewProvider(widget.branchId);
    _fill(ref.read(provider));
    ref.listenManual(provider, (_, next) => setState(() => _fill(next)));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _fill(AsyncValue<BranchReview?> loaded) {
    if (_filled || !loaded.hasValue) return;
    _filled = true;
    final review = loaded.value;
    if (review == null) return;
    _text.text = review.text ?? '';
    _rating = review.rating;
  }

  Future<void> _send() async {
    setState(() {
      _sending = true;
      _sendError = null;
    });
    try {
      await ref
          .read(branchReviewProvider(widget.branchId).notifier)
          .send(rating: _rating, text: _text.text);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sendError = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final loaded = ref.watch(branchReviewProvider(widget.branchId));

    if (!loaded.hasValue) {
      if (loaded.isLoading) return const _Loading();
      return LoadErrorRow(
        onRetry: () => ref.invalidate(branchReviewProvider(widget.branchId)),
      );
    }

    // Scrolls when the keyboard leaves less room than the form needs.
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AbsorbPointer(
              absorbing: _sending,
              child: DSRatingInput(
                value: _rating,
                onChanged: (rating) => setState(() => _rating = rating),
                starLabel: l10n.ratingStar,
              ),
            ),
          ),
          const SizedBox(height: DSSpacing.base),
          DSTextArea(
            controller: _text,
            hintText: l10n.feedbackHint,
            maxLength: BranchReviewSheet._maxTextLength,
            enabled: !_sending,
          ),
          if (_sendError case final error?) ...[
            const SizedBox(height: DSSpacing.sm),
            Text(
              errorText(context, error),
              style: DSTypography.bodySm.copyWith(color: colors.textError),
            ),
          ],
          const SizedBox(height: DSSpacing.base),
          DSButton(
            label: l10n.send,
            size: DSButtonSize.sm,
            fullWidth: true,
            loading: _sending,
            // A rating is at least one star.
            onPressed: _rating == 0 ? null : _send,
          ),
        ],
      ),
    );
  }
}

/// The form's shapes while the earlier rating loads.
class _Loading extends StatelessWidget {
  const _Loading();

  static const _stars = 5;
  static const _lines = 4;

  @override
  Widget build(BuildContext context) {
    const star = DSSizes.iconLg + DSSpacing.xxs * 2;
    final line =
        MediaQuery.textScalerOf(context).scale(DSTypography.bodySm.fontSize!) *
        DSTypography.bodySm.height!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DSSkeleton.box(
          width: star * _stars + DSSpacing.xs * (_stars - 1),
          height: star,
        ),
        const SizedBox(height: DSSpacing.base),
        DSSkeleton.box(
          width: double.infinity,
          height: line * _lines + DSSpacing.sm * 2,
          radius: DSRadius.input,
        ),
        const SizedBox(height: DSSpacing.base),
        const DSSkeleton.box(
          width: double.infinity,
          height: DSSizes.buttonHeightSm,
        ),
      ],
    );
  }
}
