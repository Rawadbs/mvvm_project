// onBoarding Models
class SliderObject {
  String title;
  String subtitle;
  String image;

  SliderObject(this.title, this.subtitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSLides;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numOfSLides, this.currentIndex);
}

//login models
class Customer {
  String id;
  String name;
  int numOfNotifications;
  Customer(this.id, this.name, this.numOfNotifications);
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer, this.contacts);
}

class Service {
  int id;
  String title;
  String image;
  Service(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;
  BannerAd(this.id, this.title, this.image, this.link);
}

class Store {
  int id;
  String title;
  String image;
  Store(this.id, this.title, this.image);
}

class HomeData {
  List<Service> services;

  List<BannerAd> banners;

  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData data;
  HomeObject(this.data);
}

class StoreDetails {
  int id;
  String title;
  String image;
  String details;
  String services;
  String about;

  StoreDetails(
      this.id, this.title, this.image, this.details, this.services, this.about);
}
