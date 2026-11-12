import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../design_system/components/overlays/ds_bottom_sheet.dart';
import '../../../design_system/ds_extensions.dart';
import '../../../domain/entities/branch.dart';

/// Opens the map with [branch] on it in a sheet titled with the branch's
/// name. Only for a branch whose coordinates are known
/// ([BranchMapSheet.canShow]).
///
/// A drag over the map moves the map; the sheet is dragged down by its
/// handle and title.
Future<void> showBranchMap(BuildContext context, Branch branch) =>
    showDSBottomSheet<void>(
      context: context,
      title: branch.name,
      child: BranchMapSheet(
        latitude: branch.latitude!,
        longitude: branch.longitude!,
      ),
    );

/// A map centred on one point with a pin on it (handoff `MapBottomSheet`).
/// It can be moved and zoomed.
class BranchMapSheet extends ConsumerWidget {
  const BranchMapSheet({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  static bool canShow(Branch branch) =>
      branch.latitude != null && branch.longitude != null;

  /// Shows a few streets around the point, as the handoff's map does.
  static const _zoom = 15.0;

  /// How the app names itself to the tile server.
  // TODO: read the application id of the build (package_info_plus) instead
  // of this copy of it; it differs per white-label client.
  static const _userAgent = 'com.example.gastro_suit';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final config = ref.watch(appConfigProvider);
    final point = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(DSRadius.md),
      child: SizedBox(
        height: DSSizes.branchMapHeight,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: _zoom,
            // Shows while the tiles load.
            backgroundColor: colors.bgSurfaceSunken,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: config.mapTileUrl,
              userAgentPackageName: _userAgent,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: DSSizes.iconXl,
                  height: DSSizes.iconXl,
                  // The pin's tip, not its middle, stands on the point.
                  alignment: Alignment.topCenter,
                  child: Icon(
                    PhosphorIconsFill.mapPin,
                    size: DSSizes.iconXl,
                    color: colors.brandPrimary,
                  ),
                ),
              ],
            ),
            // The tile provider's licence requires its credit on the map.
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: ColoredBox(
                color: colors.bgSurface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DSSpacing.xs),
                  child: Text(
                    config.mapAttribution,
                    style: DSTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
