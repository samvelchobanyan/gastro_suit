import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../dto/wallet_dto.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Wallet> getWallet({required String restaurantId}) async {
    final json = await _api.get(
      '/wallet/balance',
      query: {'restaurantId': restaurantId},
    );
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return WalletDto.fromJson(json).toDomain();
  }

  @override
  Future<bool> topUp(int amount) async {
    // No payment gateway is named: the server pays through its default.
    final json = await _api.post('/wallet/top-up', data: {'amount': amount});
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    // A gateway that needs no page says how it went; one with a page sends
    // the page and no `success`.
    return switch (json['success']) {
      true => true,
      false => throw AppException(
        AppExceptionKind.server,
        code: json['code'] as String?,
        message: json['error'] as String?,
      ),
      _ => false,
    };
  }
}
