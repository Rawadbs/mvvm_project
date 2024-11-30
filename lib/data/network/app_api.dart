import 'package:advance_flutter/app/constants.dart';
import 'package:advance_flutter/data/response/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/customers/login")
  Future<AuthenticationResponse> login(
      @Field("email") String email, @Field("password") String password);

  @POST("/customers/forgotPassword")
  Future<ForgotPasswordResponse> forgotpassword(
    @Field("email") String email,
  );

  @POST("/customers/register")
  Future<AuthenticationResponse> register(
    @Field("user_name") String username,
    @Field("country_mobile_code") String countryMobileCode,
    @Field("mobile_number") String mobileNumber,
    @Field("email") String email,
    @Field("password") String password,
    @Field("profile_picture") String profilePicture,
  );
  @GET("/home")
  Future<HomeResponse> getHomeData();
  
  @GET("/storeDetails/1")
  Future<StoreDetailsResponse> getStoreDetails();
}
