import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/order_dto.dart';
import 'package:gastro_suit/data/dto/payment_card_dto.dart';
import 'package:gastro_suit/domain/entities/order.dart';

void main() {
  const language = ContentLanguage(current: 'ru', fallback: 'en');

  // As the dev server answers, shortened.
  Map<String, dynamic> order({String status = 'placed', String? scheduledAt}) =>
      {
        'id': 'c55e7956',
        'orderNumber': 'GP-MWJ4E40B-4370E1BD31',
        'status': status,
        'paymentStatus': 'captured',
        'scheduledAt': scheduledAt,
        'locationId': 'b1',
        'location': {
          'id': 'b1',
          'internalName': 'Coffee House — Northern Avenue',
          'name': {'en': 'Northern Avenue', 'ru': 'Северный проспект'},
        },
        'totalToCharge': 1500,
        'gatewayOrderId': 'mock-payment-004ce87d',
        'posNumber': 'GP-2129',
        'items': <Object>[],
      };

  test('an order has its branch in the app\'s language', () {
    final placed = OrderPlacedDto.fromJson({
      'order': order(),
    }).toDomain(language);

    expect(placed.order.id, 'c55e7956');
    expect(placed.order.status, OrderStatus.placed);
    expect(placed.order.number, 'GP-2129');
    expect(placed.order.branchName, 'Северный проспект');
    expect(placed.order.scheduledAt, isNull);
    // Paid already: nothing to pay it by.
    expect(placed.paymentReference, isNull);
  });

  test('an order that awaits payment says what to pay it by', () {
    final placed = OrderPlacedDto.fromJson({
      'order': order(status: 'payment_pending'),
      'paymentFormUrl': '/mock-payment?orderId=mock-payment-004ce87d',
    }).toDomain(language);

    expect(placed.order.status, OrderStatus.awaitingPayment);
    expect(placed.paymentReference, 'mock-payment-004ce87d');
  });

  test('the time an order is wanted for is the device\'s own', () {
    final placed = OrderPlacedDto.fromJson({
      'order': order(scheduledAt: '2026-11-16T14:30:00.000Z'),
    }).toDomain(language);

    final time = placed.order.scheduledAt!;
    expect(time.isUtc, isFalse);
    expect(time.toUtc(), DateTime.utc(2026, 11, 16, 14, 30));
  });

  test('statuses are told apart; an unknown one is an order just placed', () {
    OrderStatus of(String? status) => OrderDto.fromJson({
      'id': 'o',
      'status': status,
    }).toDomain(language).status;

    expect(of('payment_pending'), OrderStatus.awaitingPayment);
    expect(of('paid'), OrderStatus.placed);
    expect(of('placed'), OrderStatus.placed);
    expect(of('accepted'), OrderStatus.accepted);
    expect(of('preparing'), OrderStatus.preparing);
    expect(of('ready'), OrderStatus.ready);
    expect(of('completed'), OrderStatus.collected);
    expect(of('cancelled'), OrderStatus.cancelled);
    expect(of('payment_failed'), OrderStatus.paymentFailed);
    expect(of('something_new'), OrderStatus.placed);
    expect(of(null), OrderStatus.placed);
  });

  test('a saved card is known by its last digits', () {
    final card = PaymentCardDto.fromJson({
      'bindingId': 'mock-card-18c7c02a',
      'maskedPan': '411111******1111',
      'expiryDate': '2027-12',
      'isDefault': true,
    }).toDomain();

    expect(card.id, 'mock-card-18c7c02a');
    expect(card.lastDigits, '1111');
    expect(card.isDefault, isTrue);
  });
}
