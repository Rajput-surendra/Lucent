import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://alphawizzserver.com/car_wash/api/";
  static const String imageUrl = "https://alphawizzserver.com/car_wash/";
  static const String baseUrl1 = "https://alphawizzserver.com/car_wash/user/app/v1/api/";

  static const String sendOTP = baseUrl+'send_otp';
  static const String verifyOtp = baseUrl+'verify_otp';
  static const String login = baseUrl+'login';
  static const String userRegister = baseUrl+'signup';
  static const String getUserProfile = baseUrl+'profile';
  static const String getSlider = baseUrl + 'get_slider';
  static const String getupdateUser = baseUrl+'update_profile';
  static const String getBrandApi = baseUrl + 'get_brands';
  static const String getModelApi = baseUrl+'get_models';
  static const String getAccessoriesApi = baseUrl+'get_accessories';
  static const String submitEnquiryApi = baseUrl+'enquiry';
  static const String getEnquiryListApi = baseUrl+'enquiry_list';
  static const String getPlanPurchasApi = baseUrl+'purchase_subscription';
  static const String getSubsriptionApi = baseUrl+'subscription_plans';
  static const String getSubsriptionListApi = baseUrl+'subscribed_plans';
  static const String getPrivacyPolicyApi = baseUrl+'static_pages/privacy-policy';
  static const String getContactUsApi = baseUrl+'static_pages/contact-us';
  static const String getTermsConditionsApi = baseUrl+'static_pages/terms-conditions';
  static const String getTimeSlotApi = baseUrl+'time_slots';
  static const String getStaticServiceApi = baseUrl+'general_setting1';
  static const String getAreaSubApi = baseUrl+'get_area';
  static const String getCitySubApi = baseUrl+'get_cities';
  static const String checkPromoCodeApi = baseUrl+'check_promo_code';
  static const String getPromoCodeApi = baseUrl+'get_promo_code';
  static const String getGeneratePaytmApi = baseUrl+'generate_paytm_txn_token';



  static const String getEvents = baseUrl+'get_events';


    static const String getWebinar = baseUrl+'get_webinar';
  static const String getNewType = baseUrl+'get_news_type';
  static const String selectCategory = baseUrl+'select_category';
  static const String getCounting = baseUrl+'get_counting';
  static const String getEditorial = baseUrl+'get_editorial';
  static const String addDoctorNews = baseUrl+'add_doctor_news';
  static const String addDoctorAwreness = baseUrl+'add_awareness';
  static const String addDoctorWebiner = baseUrl+'add_doctor_webinar';
  static const String addDoctorEditorial = baseUrl+'add_doctor_editorial';
  static const String addDoctorEvent = baseUrl+'add_doctor_event';
  static const String getAwareness = baseUrl+'get_awareness';
  static const String getSettings = baseUrl+'get_settings';
  static const String getPharmaCategory = baseUrl+'select_category';
  static const String getPharmaProductsCategory = baseUrl+'pharma_category';
  static const String getPharmaProductsCategoryNew = baseUrl+'get_categories_product';
  static const String getPharmaProducts = baseUrl+'get_products';
  static const String getUserCart = baseUrl+'get_user_cart';
  static const String getPlaceOrderApi = baseUrl+'place_order';
  static const String getRemoveCartApi = baseUrl+'remove_from_cart';
  static const String getManageCartApi = baseUrl+'manage_cart';
  static const String addDoctorWebinar = baseUrl+'add_doctor_webinar';
  static const String addNewWishListApi = baseUrl+'add_news_wishlist';
  static const String getNewsWishListApi = baseUrl+'get_news_wishlist';
  static const String getRemoveWishListApi = baseUrl+'remove_wishlist';
  static const String addProductApi = baseUrl+'add_products';
  static const String getHistoryApi = baseUrl+'get_user_history';
  static const String getHistoryDeleteApi = baseUrl+'delete_data';
  static const String getCompaniesApi = baseUrl+'get_companies';
  static const String getCompaniesDropApi = baseUrl+'get_company';
  static const String getStateApi = baseUrl1+'get_states';
  static const String getCityApi = baseUrl1+'get_cities';
  static const String getPlaceApi = baseUrl1+'get_places';


    static const String getCheckSubscriptionApi = baseUrl+'check_subscription';
    static const String getUploadBannerApi = baseUrl+'upload_banner';
    static const String getBooking = baseUrl+'bookings';
}
