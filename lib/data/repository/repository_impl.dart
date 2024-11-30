import 'package:advance_flutter/data/data_source/local_data_source.dart';
import 'package:advance_flutter/data/data_source/remote_data_source.dart';
import 'package:advance_flutter/data/mapper/mapper.dart';
import 'package:advance_flutter/data/network/error_handler.dart';
import 'package:advance_flutter/data/network/failure.dart';
import 'package:advance_flutter/data/network/network_info.dart';
import 'package:advance_flutter/data/network/requests.dart';
import 'package:advance_flutter/domain/models/models.dart';
import 'package:advance_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginrequest) async {
    if (await _networkInfo.isConected) {
      //its connected to internet, its safe to call api
      try {
        final response = await _remoteDataSource.login(loginrequest);
        if (response.status == ApiInternalSataus.SUCCESS) {
          //success
          //return either right
          //return data
          return Right(response.toDomain());
        } else {
          //failure -- return business error
          //return either left
          return Left(Failure(ApiInternalSataus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //return either left
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      //return  internet error
      //return either left
      return Left(DataSource.NO_INTERNET_CONECTTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalSataus.SUCCESS) {
          // success
          // return right
          return Right(response.toDomain());
        } else {
          // failure
          // return left
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return network connection error
      // return left
      return Left(DataSource.NO_INTERNET_CONECTTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConected) {
      //its connected to internet, its safe to call api
      try {
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalSataus.SUCCESS) {
          //success
          //return either right
          //return data
          return Right(response.toDomain());
        } else {
          //failure -- return business error
          //return either left
          return Left(Failure(ApiInternalSataus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //return either left
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      //return  internet error
      //return either left
      return Left(DataSource.NO_INTERNET_CONECTTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConected) {
        try {
          // its safe to call API
          final response = await _remoteDataSource.getHomeData();

          if (response.status == ApiInternalSataus.SUCCESS) {
            // success
            // return right
            // return data
            // save home response to cache
            // save response in cache(local data source )
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            // failure
            // return left
            return Left(Failure(response.status ?? ResponseCode.DEFAULT,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return network connection error
        // return left
        return Left(DataSource.NO_INTERNET_CONECTTION.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async {
    try {
      // get data from cache

      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConected) {
        try {
          final response = await _remoteDataSource.getStoreDetails();
          if (response.status == ApiInternalSataus.SUCCESS) {
            _localDataSource.saveStoreDetailsToCache(response);
            return Right(response.toDomain());
          } else {
            return Left(Failure(response.status ?? ResponseCode.DEFAULT,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONECTTION.getFailure());
      }
    }
  }
}
