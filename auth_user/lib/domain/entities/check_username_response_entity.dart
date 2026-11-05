import 'package:equatable/equatable.dart';

class CheckUsernameResponseEntity extends Equatable {
  final bool isAvailable;
  final String? message;

  const CheckUsernameResponseEntity({
    required this.isAvailable,
    this.message,
  });

  @override
  List<Object?> get props => [isAvailable, message];
}
