import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';
import '../auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authRepository = authenticationRepository,
        super(authenticationRepository.isLoggedIn
            ? Authenticated()
            : UnAuthenticated()) {
    log('${authenticationRepository.currentUser}');
    on<AppUserChanged>(_onUserChanged);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<Logout>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(AppUserChanged()),
    );
  }

  final AuthenticationRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AuthState> emit) {
    emit(
      _authRepository.isLoggedIn ? Authenticated() : UnAuthenticated(),
    );
  }

  void _onLogoutRequested(Logout event, Emitter<AuthState> emit) async {
    _authRepository.logOut();
    emit(UnAuthenticated());
  }

  void _onGoogleSignIn(GoogleSignIn event, Emitter<AuthState> emit) async {
    _authRepository.logInWithGoogle();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
