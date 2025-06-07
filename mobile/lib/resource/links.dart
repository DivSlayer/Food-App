class Links {
  static String server = 'http://172.17.49.238:8000';
  static String registerURL = '$server/api/account/register';
  static String serverCheckURL = '$server/api/check';
  static String getUserURL = '$server/api/account/details';
  static String loginURL = '$server/api/account/login';
  static String updateTokenURL = '$server/api/account/token/refresh';
  static String getTokenURL = '$server/api/account/token';
  static String addAddressURL = '$server/api/address/';
  static String categoriesListURL = '$server/api/category';
  static String extrasListURL(String uuid) => '$server/api/extra/$uuid';
  static String instructionsListURL(String uuid) => '$server/api/instruction/$uuid';
  static String closeRestaurantURL = '$server/api/restaurant/close-res';
  static String transactionsURL = '$server/api/transaction';
  static String singleRestaurantURL(String uuid) => '$server/api/restaurant/$uuid';
  static String singleFoodURL(String uuid) => '$server/api/food/$uuid';
  static String checkFoods = '$server/api/food/check/';
  static String getFoods = '$server/api/food';
  static String commentsURL(String uuid) => '$server/api/comment/$uuid';
  static String searchURL(query) => "$server/api/search?q=$query";
  static String bannerURL = "$server/api/banner";
}
