import 'package:advance_flutter/data/network/error_handler.dart';
import 'package:advance_flutter/data/response/responses.dart';

const cacheHomeKey = 'CACHE_HOME_KEY';
const cacheHomeInterval = 60 * 1000;
const CACHE_STORE_DETAILS_KEY = "CACHE_STORE_DETAILS_KEY";
const CACHE_STORE_DETAILS_INTERVAL = 60 * 1000; // 30s in millis

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);
  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response);
}

class LocalDataSourceImpl implements LocalDataSource {
  // run time cache
  Map<String, CashedItem> cacheMap = {};

  @override
  Future<HomeResponse> getHomeData() async {
    CashedItem? cashedItem = cacheMap[cacheHomeKey];
    if (cashedItem != null && cashedItem.isValid(cacheHomeInterval)) {
      return cashedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[cacheHomeKey] = CashedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    CashedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];

    if (cachedItem != null &&
        cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response) async {
    cacheMap[CACHE_STORE_DETAILS_KEY] = CashedItem(response);
  }
}

class CashedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CashedItem(this.data);
}

extension CashedItemExtension on CashedItem {
  bool isValid(int expirationTimeInMilis) {
    int currentTimeInMilis = DateTime.now().millisecondsSinceEpoch;
    bool isValid = currentTimeInMilis - cacheTime < expirationTimeInMilis;
    return isValid;
  }
}
