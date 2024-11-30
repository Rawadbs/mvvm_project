import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:advance_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class StoreDetailsUsecase implements BaseUsecase<void, StoreDetails> {
  final Repository _repository;
  StoreDetailsUsecase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await _repository.getStoreDetails();
  }
}
