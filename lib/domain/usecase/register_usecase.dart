import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/data/network/requests.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:advance_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase
    implements BaseUsecase<RegisterUsecaseInput, Authentication> {
  final Repository _repository;
  RegisterUsecase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUsecaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.userName,
        input.countryMobileCode,
        input.mobileNumber,
        input.email,
        input.password,
        input.profilePicture));
  }
}

class RegisterUsecaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;
  RegisterUsecaseInput(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}
