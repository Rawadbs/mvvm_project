import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:advance_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUsecase implements BaseUsecase<void, HomeObject> {
  final Repository _repository;
  HomeUsecase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> execute(
      void input) async {
    return await _repository.getHomeData();
  }
}
