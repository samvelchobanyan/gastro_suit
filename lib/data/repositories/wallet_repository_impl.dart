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
}
