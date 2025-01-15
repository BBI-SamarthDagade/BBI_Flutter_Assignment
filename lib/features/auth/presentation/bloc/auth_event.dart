import 'package:ecommerce/features/auth/domain/entities/auth_entity.dart';

abstract class AuthEvent {
  
}

class ContinueWithGoogleEvent extends AuthEvent{
    
}

class SignInWithEmailEvent extends AuthEvent{
    AuthEntity authEntity;

    SignInWithEmailEvent(this.authEntity);
}

class SignOutEvent extends AuthEvent{

}

class SignUpWithEmailEvent extends AuthEvent{
   AuthEntity authEntity;
   SignUpWithEmailEvent(this.authEntity);
}