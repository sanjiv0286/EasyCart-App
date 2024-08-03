// class API {
//   static const hostConnect = "http://192.168.230.69/api_clothes_store";
//   // static const hostConnectUser = "http://192.168.93.21/api_clothes_store/user";
//   static const hostConnectUser = "$hostConnect/user";
//   // *signup user
//   static const signUp = "$hostConnect/user/signup.php";
//   static const login = "$hostConnect/user/login.php";
//   static const validateEmail = "$hostConnect/user/validate_email.php";
// }
class API {
  static const hostConnect = "http://192.168.213.21/api_clothes_store";
  // static const hostConnect =
  // "http://php119.infinityfreeapp.com/185.27.134.144/api_clothes_store";

  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostItem = "$hostConnect/items";
  static const hostClothes = "$hostConnect/clothes";
  static const hostCart = "$hostConnect/cart";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";
  static const hostImages = "$hostConnect/transactions_proof_images/";

  //*signUp-Login user
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";

  //login admin
  static const adminLogin = "$hostConnectAdmin/login.php";
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php";

  //items
  static const uploadNewItem = "$hostItem/upload.php";
  static const searchItems = "$hostItem/search.php";

  //Clothes
  static const getTrendingMostPopularClothes = "$hostClothes/trending.php";
  static const getAllClothes = "$hostClothes/all.php";

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteSelectedItemsFromCartList = "$hostCart/delete.php";
  static const updateItemInCartList = "$hostCart/update.php";

  //favorite
  static const validateFavorite = "$hostFavorite/validate_favorite.php";
  static const addFavorite = "$hostFavorite/add.php";
  static const deleteFavorite = "$hostFavorite/delete.php";
  static const readFavorite = "$hostFavorite/read.php";

  //order
  static const addOrder = "$hostOrder/add.php";
  static const readOrders = "$hostOrder/read.php";
  static const updateStatus = "$hostOrder/update_status.php";
  static const readHistory = "$hostOrder/read_history.php";
}
