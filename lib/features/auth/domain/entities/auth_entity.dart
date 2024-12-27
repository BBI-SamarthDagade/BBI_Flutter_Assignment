import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  String userId;

  AuthEntity({required this.userId});
  
  @override
  List<Object?> get props => throw UnimplementedError();
  
}    

