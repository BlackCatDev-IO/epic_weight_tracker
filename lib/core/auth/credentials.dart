import 'package:objectbox/objectbox.dart';

@Entity()
class Credential {
  Credential({
    required this.id,
    required this.providerId,
    required this.signInMethod,
    this.token,
    this.accessToken,
  });

  @Id(assignable: true)
  int id;
  String providerId;
  String signInMethod;
  String? accessToken;
  int? token;
}
