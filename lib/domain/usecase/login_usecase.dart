import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/data/network/requests.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:advance_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase implements BaseUsecase<LoginUsecaseInput, Authentication> {
  final Repository _repository;
  LoginUsecase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUsecaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUsecaseInput {
  String email;
  String password;
  LoginUsecaseInput(this.email, this.password);
}
