import 'package:equatable/equatable.dart';

import 'package:objectbox/objectbox.dart';

@Entity()
class User extends Equatable {
  const User(
      {required this.id, required this.email, this.weight, required this.uid});

  @Id(assignable: true)
  final int id;
  final String? uid;
  final String email;
  final double? weight;

  @override
  List<Object?> get props => [id, uid, email, weight];

  @override
  String toString() {
    return 'User: id: $id, uid: $uid, email: $email, weight: $weight';
  }
}
