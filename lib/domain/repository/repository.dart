import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/data/network/requests.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginrequest);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, HomeObject>> getHomeData();
  Future<Either<Failure, StoreDetails>> getStoreDetails();
}
