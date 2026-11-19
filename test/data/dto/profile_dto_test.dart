import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/data/dto/profile_dto.dart';
import 'package:gastro_suit/domain/entities/profile.dart';

void main() {
  // As the dev server answers.
  test('a profile has the name, the contacts and the photo', () {
    final profile = ProfileDto.fromJson({
      'id': 'u-1',
      'phone': '+37491234567',
      'email': 'aram@example.com',
      'emailVerified': true,
      'name': 'Aram',
      'surname': 'Shahinyan',
      'gender': 'female',
      'city': 'city-1',
      'photoUrl': 'http://test/photo.jpg',
      'dateOfBirth': '1995-03-12',
      'language': 'en',
      'role': 'guest',
      'preferredLocationId': null,
      'marketingConsentPush': false,
      'favoriteItemIds': ['p-1', 'p-2'],
      'hasPassword': true,
      'createdAt': '2026-11-01T10:00:00.000Z',
    }).toDomain();

    expect(profile.fullName, 'Aram Shahinyan');
    expect(profile.contact, '+37491234567');
    expect(profile.photoUrl, 'http://test/photo.jpg');
    expect(profile.birthday, DateTime(1995, 3, 12));
    expect(profile.city, 'city-1');
    expect(profile.gender, Gender.female);
  });

  test('a user without a phone or a name is known by the email', () {
    final profile = ProfileDto.fromJson({
      'phone': null,
      'email': 'test@test.com',
      'name': null,
      'surname': '',
      'photoUrl': '',
    }).toDomain();

    expect(profile.fullName, isEmpty);
    expect(profile.contact, 'test@test.com');
    expect(profile.photoUrl, isNull);
    expect(profile.birthday, isNull);
    expect(profile.city, isNull);
    expect(profile.gender, isNull);
  });

  test('a change is sent whole, and what is not given clears', () {
    expect(
      ProfileDto.changes(
        name: 'Aram',
        surname: 'Shahinyan',
        birthday: DateTime(1995, 3, 5),
        city: 'city-1',
        gender: Gender.male,
      ),
      {
        'name': 'Aram',
        'surname': 'Shahinyan',
        'dateOfBirth': '1995-03-05',
        'city': 'city-1',
        'gender': 'male',
      },
    );
    expect(
      ProfileDto.changes(
        name: '',
        surname: '',
        birthday: null,
        city: null,
        gender: null,
      ),
      {
        'name': '',
        'surname': '',
        'dateOfBirth': null,
        'city': '',
        'gender': null,
      },
    );
  });
}
