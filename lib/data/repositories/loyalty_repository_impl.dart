import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/loyalty_card.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../dto/loyalty_dto.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  LoyaltyRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<LoyaltyCard> getCard({required String restaurantId}) async {
    final query = {'restaurantId': restaurantId};
    // The balance and the card's number are two requests, made together.
    final (balance, qr) = await (
      _api.get('/loyalty/balance', query: query),
      _api.get('/loyalty/counter-qr', query: query),
    ).wait;
    if (balance is! Map<String, dynamic> || qr is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    final number = CounterQrDto.fromJson(qr).cardNumber;
    // A card that cannot be scanned is not a card.
    if (number == null || number.isEmpty) {
      throw const AppException(AppExceptionKind.unknown);
    }
    final dto = LoyaltyBalanceDto.fromJson(balance);
    final tier = dto.tier?.trim();
    return LoyaltyCard(
      points: dto.points?.round() ?? 0,
      number: number,
      tier: tier == null || tier.isEmpty ? null : tier,
    );
  }
}
