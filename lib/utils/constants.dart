import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

/// DO NOT CHANGE THIS Keys
const APP_PACKAGE_NAME = "com.iconic.socialv";
const WEB_SOCKET_URL = "wss://realtime-cloud.bpbettermessages.com/socket.io/?EIO=4&transport=websocket";

/// Radius
double commonRadius = 8.0;

String? fontFamily = GoogleFonts.plusJakartaSans().fontFamily;

/// REGION LIVESTREAM KEYS

const tokenStream = 'tokenStream';

const String openDocUrlPrefix = 'https://docs.google.com/gview?embedded=true&url=';
const String docViewerPrefix = 'https://docs.google.com/viewerng/viewer?url=';

const PER_PAGE = 10;
const DATE_FORMAT_1 = 'yyyy-MM-dd HH:mm:ss';
const DATE_FORMAT_2 = 'yyyy-MM-DDTHH:mm:ss';
const DATE_FORMAT_3 = 'dd-MM-yyyy';
const DATE_FORMAT_4 = 'yyyy-MM-dd';
const DATE_FORMAT_5 = 'dd, MM yyyy';
const TIME_FORMAT_1 = 'hh:mm a';
const DISPLAY_DATE_FORMAT = 'MMMM d, y';

const storyDuration = "3";

const updateActiveStatusDuration = 10;

const ARTICLE_LINE_HEIGHT = 1.5;

//region LiveStream Keys
const OnGroupRequestAccept = 'OnGroupRequestAccept';
const OnRequestAccept = 'OnRequestAccept';
const OnAddPost = 'OnAddPost';
const OnAddPostProfile = 'OnAddPostProfile';
const GetUserStories = 'GetUserStories';
const GetTopicDetail = 'GetTopicDetail';
const RefreshForumsFragment = 'RefreshForumsFragment';
const RefreshNotifications = 'RefreshNotifications';
const STREAM_FILTER_ORDER_BY = 'STREAM_FILTER_ORDER_BY';
const ThreadMessageReceived = 'ThreadMessageReceived';
const RefreshRecentMessage = 'RefreshRecentMessage';
const ThreadStatusChanged = 'ThreadStatusChanged';
const RecentThreadStatus = 'RecentThreadStatus';
const MetaChanged = 'MetaChanged';
const DeleteMessage = 'DeleteMessage';
const RefreshRecentMessages = 'RefreshRecentMessages';
const SendMessage = 'SendMessage';
const FastMessage = 'FastMessage';
const AbortFastMessage = 'AbortFastMessage';
const RefreshDashboard = 'RefreshDashboard';

//endregion

/// Demo Login
const DEMO_USER_EMAIL = "jerry@gmail.com";
const DEMO_USER_PASSWORD = "123456";

/// Firebase Notification Key

class Constants {
  static const defaultLanguage = 'en';
}

class SharePreferencesKey {
  static const TOKEN = 'TOKEN';
  static const NONCE = 'NONCE';
  static const VERIFICATION_STATUS = 'VERIFICATION_STATUS';
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const WOO_CURRENCY = 'WOO_CURRENCY';
  static const GIPHY_API_KEY = 'GIPHY_API_KEY';
  static const IOS_GIPHY_API_KEY = 'IOS_GIPHY_API_KEY';
  static const BM_SECRET_KEY = 'BM_SECRET_KEY';
  static const USERNAME_KEY = 'USERNAME_KEY';
  static const USER_AVATAR_KEY = 'USER_AVATAR_KEY';
  static const FILTER_CONTENT = 'FILTER_CONTENT';

  static const REMEMBER_ME = 'REMEMBER_ME';

  static const LOGIN_EMAIL = 'LOGIN_EMAIL';
  static const LOGIN_PASSWORD = 'LOGIN_PASSWORD';
  static const LOGIN_FULL_NAME = 'LOGIN_FULL_NAME';
  static const LOGIN_DISPLAY_NAME = 'LOGIN_DISPLAY_NAME';
  static const LOGIN_USER_ID = 'LOGIN_USER_ID';
  static const LOGIN_AVATAR_URL = 'LOGIN_AVATAR_URL';
  static const APP_THEME = 'APP_THEME';
  static const IS_DARK_MODE = 'IS_DARK_MODE';
  static const LANGUAGE = "LANGUAGE";

  static const RECENT_SEARCH_MEMBERS = 'RECENT_SEARCH_MEMBERS';
  static const RECENT_SEARCH_GROUPS = 'RECENT_SEARCH_GROUPS';
  static const LMS_QUIZ_LIST = 'LMS_QUIZ_LIST';

  static const PMP_CURRENCY = 'PMP_CURRENCY';
  static const PMP_ENABLE = 'PMP_ENABLE';
  static const PMP_MEMBERSHIP = 'PMP_MEMBERSHIP';

  static const HAS_IN_REVIEW = 'HAS_IN_REVIEW';
  static const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';

  static const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';

  static const LAST_APP_CONFIGURATION_CALL_TIME = 'APP_CONFIGURATION_CALL_TIME';

  static const lastTimeWoocommerceNonceGenerated = 'Last Time Woocommerce Nonce Generated';

  static const lastTimeCheckMessagesSettings = 'Messages Settings';

  static const lastTimeCheckEmojisReactions = 'Emojis Reactions';

  static const lastTimeCheckChatUserSettings = 'User Chat Settings';

  static const isAPPConfigurationCalledAtLeastOnce = 'isAPPConfigurationCalledAtLeastOnce';

  static const String firebaseToken = 'Firebase Token';

  static const String hasInAppSubscription = "hasInAppSubscription";
  static const String inAppActiveSubscription = "inAppActiveSubscription";

  //region General SettingsKeys
  // Int type keys
  static const String isAccountVerificationRequire = "is_account_verification_require";
  static const String showAds = "show_ads";
  static const String showBlogs = "show_blogs";
  static const String freeSubscription = "free subscription";
  static const String showSocialLogin = "show_social_login";
  static const String showShop = "show_shop";
  static const String showGamiPress = "show_gamipress";
  static const String showLearnPress = "show_learnpress";
  static const String showMembership = "show_membership";
  static const String showForums = "show_forums";
  static const String showGIF = 'show_gif';
  static const String isGamiPressEnable = "is_gamipress_enable";
  static const String isWooCommerceEnable = "is_woocommerce_enable";
  static const String isShopEnable = "is_shop_enable";
  static const String isLmsEnable = "is_lms_enable";
  static const String isCourseEnable = "is_course_enable";
  static const String isWebSocketEnable = "is_websocket_enable";
  static const String isReactionEnable = "is_reaction_enable";
  static const String isHighlightStoryEnable = "is_highlight_story_enable";
  static const String displayPostCount = "display_post_count";
  static const String displayCommentsCount = "display_comments_count";
  static const String displayProfileViews = "display_profile_views";
  static const String displayFriendRequestBtn = "display_friend_request_btn";

  // Bool type keys
  static const String isPaidMembershipEnable = "is_paid_membership_enable";

  // String type keys
  static const String membershipPaymentType = "membership_payment_type";
  static const String wooCurrency = "woo_currency";
  static const String lmsCurrency = "lms_currency";
  static const String defaultReaction = "default_reaction";
  static const String reactions = "reactions";
  static const String giphyKey = "giphy_key";
  static const String iosGiphyKey = "ios_giphy_key";
  static const String accountPrivacyVisibility = "account_privacy_visibility";

  static const String emojiList = "emoji_list";

  // Lists and complex structures
  static const String mediapressAllowedTypes = "mediapress_allowed_types";
  static const String mediapressGroupsAllowedTypes = "mediapress_groups_allowed_types";
  static const String mediapressSitewideAllowedTypes = "mediapress_sitewide_allowed_types";
  static const String achievementType = "achievementType";
  static const String storyAllowedTypes = "story_allowed_types";
  static const String storyActions = "story_actions";
  static const String visibilities = "visibilities";
  static const String reportTypes = "report_types";
  static const String signupFields = "signup_fields";

  static const String mediaStatus = "media_status";

  //region PMPro cached Data
  static const String pmpRestrictions = 'pmpRestrictions';
  static const String pmpEnable = "pmpEnable";
  static const String canCreateGroup = "canCreateGroup";
  static const String viewSingleGroup = "viewSingleGroup";
  static const String viewGroups = "viewGroups";
  static const String canJoinGroup = "canJoinGroup";
  static const String privateMessaging = "privateMessaging";
  static const String publicMessaging = "publicMessaging";
  static const String sendFriendRequest = "sendFriendRequest";
  static const String memberDirectory = "memberDirectory";

  static const String cartCount = 'cart_count';

  // region inApp cached data
  static const String entitlement_id = 'entitlement_id';
  static const String apple_api_key = 'apple_api_key';
  static const String google_api_key = 'google_api_key';

//endregion

  //region CachedData
  static const cachedPostList = 'Cached Post List';
//endregion
}

//region LOGIN TYPE

const APPLE_EMAIL = 'APPLE_EMAIL';
const APPLE_GIVE_NAME = 'APPLE_GIVE_NAME';
const APPLE_FAMILY_NAME = 'APPLE_FAMILY_NAME';

const LOGIN_TYPE_USER = 'user';
const LOGIN_TYPE_GOOGLE = 'google';
const LOGIN_TYPE_OTP = 'mobile';
const LOGIN_TYPE_APPLE = 'apple';

class APIEndPoint {
  static const login = 'jwt-auth/v1/token';
  static const getMembers = 'buddypress/v1/members';
  static const coverImage = 'cover';
  static const avatarImage = 'avatar';
  static const groupMembers = 'members';
  static const groupMembershipRequests = 'membership-requests';
  static const getFriends = 'buddypress/v1/friends';
  static const getNotifications = 'socialv/api/v1/notifications';
  static const buddypressNotifications = 'buddypress/v1/notifications';
  static const viewStory = 'seen';
  static const getBlockedMembers = 'socialv/api/v1/moderation/members/blocked';
  static const productsList = 'wc/v3/products';
  static const productReviews = 'wc/v3/products/reviews';
  static const cartItems = 'wc/store/cart/items';
  static const cart = 'wc/store/cart';
  static const applyCoupon = 'wc/store/cart/apply-coupon';
  static const removeCoupon = 'wc/store/cart/remove-coupon';
  static const coupons = 'wc/v3/coupons';
  static const addCartItems = 'wc/store/cart/add-item';
  static const removeCartItems = 'wc/store/cart/remove-item';
  static const updateCartItems = 'wc/store/cart/update-item';
  static const getPaymentMethods = 'wc/v3/payment_gateways';
  static const categories = 'wc/v3/products/categories';
  static const orders = 'wc/v3/orders';
  static const customers = 'wc/v3/customers';
  static const wishlist = 'socialv/api/v1/woocommerce/wishlist';
  static const productDetails = 'socialv/api/v1/woocommerce/products';

  static const storeNonce = 'socialv/api/v1/woocommerce/store-api-nonce';
  static const countries = 'wc/v3/data/countries';
  static const favoriteTopic = 'socialv/api/v1/forums/topics/favorite';
  static const replyTopic = 'socialv/api/v1/forums/topics/replies';
  static const editTopicReply = 'socialv/api/v1/forums/topics/replies/edit';
  static const subscriptionList = 'socialv/api/v1/forums/subscriptions';
  static const forumRepliesList = 'socialv/api/v1/forums/topics/replies';
  static const topicList = 'socialv/api/v1/forums/topics';
  static const wpPost = 'wp/v2/posts';
  static const activity = 'buddypress/v1/activity';
  static const courses = 'learnpress/v1/courses';
  static const enrollCourse = 'learnpress/v1/courses/enroll';
  static const retakeCourse = 'learnpress/v1/courses/retake';
  static const finishCourse = 'learnpress/v1/courses/finish';
  static const courseReview = 'learnpress/v1/review/course';
  static const submitCourseReview = 'learnpress/v1/review/submit';
  static const lessons = 'learnpress/v1/lessons';
  static const finishLessons = 'learnpress/v1/lessons/finish';
  static const quiz = 'learnpress/v1/quiz';
  static const startQuiz = 'learnpress/v1/quiz/start';
  static const finishQuiz = 'learnpress/v1/quiz/finish';
  static const getReactionList = 'iqonic/api/v1/reaction/reaction-list';
  static const activityReaction = 'iqonic/api/v1/reaction/activity';
  static const commentsReaction = 'iqonic/api/v1/reaction/comment';
  static const pinActivity = 'pin';
  static const getAlbums = 'albums';
  static const mediaEndPoint = 'media';
  static const wpComments = 'wp/v2/comments';
  static const getCourseCategory = 'wp/v2/course_category';
  static const blogComment = 'socialv/api/v1/wp-posts/comments';
  static const activateAccount = 'socialv/api/v1/members/activation';
  static const activationKey = 'key';

  static const gamiPressAchievement = 'wp/v2';
  static const badges = 'wp/v2/badge';
  static const levels = 'wp/v2/levels';

  static const manageFirebaseToken = 'socialv/api/v1/members/firebase/tokens';

  //region Optimized API Endpoints

  static const socialVDashApiEndPoint = 'socialv-api/api/v1';
  static const socialVApiEndPoint = 'socialv/api/v1';
  static const membersEndPoint = 'socialv/api/v1/members';

  static const generalSettingEndPoint = 'socialv/api/v1/app/settings';
  static const registerEndPoint = 'registration';
  static const accountVerificationEndPoint = 'verification';
  static const loginEndPoint = 'login';
  static const forgotPasswordEndPoint = 'forgot-password';
  static const changePasswordEndPoint = 'change-password';
  static const accountActivationEndPoint = 'activation';
  static const profileEndPoint = 'profile';

  static const fieldsEndPoint = 'fields';

  static const notificationsEndPoint = 'notifications';

  static const visibilityEndPoint = 'visibility';
  static const deleteAccountEndPoint = 'delete';
  static const socialVActivityEndpoint = 'socialv/api/v1/activity';
  static const likesEndpoint = 'likes';
  static const commentsEndPoint = 'comments';
  static const hideEndpoint = 'hide';
  static const settingsEndPoint = 'settings';
  static const dashboardEndPoint = 'dashboard';
  static const mediaPressMediaEndPoint = 'socialv/api/v1/mediapress';
  static const userActivityStatusEndPoint = 'online-status';
  static const storiesEndPoint = 'stories';

  static const storiesListEndPoint = '';

  static const highlightEndPoint = 'highlights';

  static const categoryEndPoint = 'category';
  static const forumsEndPoint = 'forums';
  static const buddyPressGroupEndpoint = 'buddypress/v1/groups';
  static const groupsEndpoint = 'groups';
  static const invitationEndpoint = 'invitations';
  static const membersEndpoint = 'members';
  static const requestEndpoint = 'requests';
  static const usersEndPoint = 'users';
  static const userEndPoint = 'user';
  static const groupEndPoint = 'group';
  static const friendsEndPoint = 'friends';

  static const invitesEndPoint = 'invites';

  static const friendsRequestEndPoint = 'friend-requests';

  static const sentEndPoint = 'sent';
  static const suggestionEndpoint = 'suggestion';
  static const refuseEndPoint = 'refuse';

  static const methodsEndPoint = 'methods';

  static const subscriptionsEndPoint = 'subscriptions';

  static const topicsEndPoint = 'topics';

  static const detailsEndPoint = 'details';

  static const moderationEndPoint = 'socialv/api/v1/moderation';

  static const reportEndPoint = 'report';
  static const moderationMembersEndPoint = 'members';

  static const memberEndPoint = 'member';
  static const postEndPoint = 'post';

  //region learnPress
  static const learnPressEndPoint = 'learnpress';

  static const ordersEndPoint = 'orders';

  static const paymentsEndPoint = 'payments';

// endregion

  //region gamipress
  static const gamipressEndPoint = 'socialv/api/v1/gamipress/members';

  static const earningsEndPoint = 'earnings';

  static const achievementEndPoint = 'achievements';
//endregion
//endregion
}

class MessageAPIEndPoint {
  static const threads = 'better-messages/v1/threads';
  static const getFriends = 'better-messages/v1/getFriends';
  static const getGroups = 'better-messages/v1/getGroups';
  static const thread = 'better-messages/v1/thread';
  static const getPrivateThread = 'better-messages/v1/getPrivateThread';
  static const userSettings = 'better-messages/v1/userSettings';
  static const unblockUser = 'better-messages/v1/unblockUser';
  static const blockUser = 'better-messages/v1/blockUser';
  static const favorite = 'favorite';
  static const search = 'better-messages/v1/search';
  static const suggestions = 'better-messages/v1/suggestions';
  static const getFavorited = 'better-messages/v1/getFavorited';
  static const addParticipant = 'addParticipant';
  static const removeParticipant = 'removeParticipant';
  static const changeMeta = 'changeMeta';
  static const changeSubject = 'changeSubject';
  static const leaveThread = 'leaveThread';
  static const message = 'socialv/api/v1/messages';
  static const saveThread = 'better-messages/v1/reactions/save';
  static const loadMore = 'loadMore';
  static const mentionsSuggestions = 'mentionsSuggestions';
  static const restore = 'restore';
  static const chatBackground = 'socialv/api/v1/messages/chat-background';
  static const messagesSettings = 'socialv/api/v1/messages/settings';
  static const callStart = 'better-messages/v1/callStart';
  static const callStarted = 'better-messages/v1/callStarted';
  static const callUsage = 'better-messages/v1/callUsage';
  static const callMissed = 'better-messages/v1/callMissed';

  //region Optimized Api
  static const messagesEndPoint = 'messages';
  static const emojisEndPoint = 'emojis';
  static const reactionsEndPoint = 'reactions';
//endregion
}

class PMPAPIEndPoint {
  static const getMembershipLevelForUser = 'pmpro/v1/get_membership_level_for_user';
  static const changeMembershipLevel = 'pmpro/v1/change_membership_level';
  static const cancelMembershipLevel = 'pmpro/v1/cancel_membership_level';
  static const membershipLevels = 'socialv/api/v1/membership/levels';
  static const order = 'socialv/api/v1/membership/orders';
  static const membershipOrders = 'socialv/api/v1/membership/orders';
  static const paymentGateway = 'socialv/api/v1/membership/payments/gateways';
  static const restrictions = 'socialv/api/v1/membership/restrictions';
  static const discountCodes = 'socialv/api/v1/membership/discount-codes';
}

class AppImages {
  static String placeHolderImage = "assets/images/empty_image_placeholder.jpg";
  static String profileBackgroundImage = "assets/images/background_image.png";
  static String defaultAvatarUrl = "https://wordpress.iqonic.design/product/wp/socialv-app/wp-content/themes/socialv-theme/assets/images/redux/default-avatar.jpg";
}

class Users {
  static String username = 'username';
  static String password = 'password';
  static String email = 'email';
}

class StoryType {
  static String highlight = 'highlight';
  static String global = 'global';
}

class GroupImageKeys {
  static const coverActionKey = 'bp_cover_image_upload';
  static const avatarActionKey = 'bp_avatar_upload';
}

class FirebaseMsgConst {
  //region Firebase Notification
  static const additionalDataKey = 'additional_data';
  static const notificationGroupKey = 'notification_group';
  static const idKey = 'id';
  static const userWithUnderscoreKey = 'user_';
  static const notificationDataKey = 'Notification Data';
  static const fcmNotificationTokenKey = 'FCM Notification Token';
  static const apnsNotificationTokenKey = 'APNS Notification Token';
  static const notificationErrorKey = 'Notification Error';
  static const notificationTitleKey = 'Notification Title';

  static const notificationKey = 'Notification';

  static const onClickListener = "Error On Notification Click Listener";
  static const onMessageListen = "Error On Message Listen";
  static const onMessageOpened = "Error On Message Opened App";
  static const onGetInitialMessage = 'Error On Get Initial Message';

  static const messageDataCollapseKey = 'MessageData Collapse Key';

  static const messageDataMessageIdKey = 'MessageData Message Id';

  static const messageDataMessageTypeKey = 'MessageData Type';
  static const notificationBodyKey = 'Notification Body';
  static const backgroundChannelIdKey = 'background_channel';
  static const backgroundChannelNameKey = 'background_channel';

  static const notificationChannelIdKey = 'notification';
  static const notificationChannelNameKey = 'Notification';

  static const topicSubscribed = 'topic-----subscribed---->';

  static const topicUnSubscribed = 'topic-----Unsubscribed---->';

  //endregion

  //region Notification element keys
  static const isCommentKey = 'is_comment';
  static const postIdKey = 'post_id';
  static const userIdKey = 'user_id';
  static const groupIdKey = 'group_id';
  static const threadId = 'thread_id';

//endregion
}

class NotificationAction {
  static String friendshipAccepted = 'friendship_accepted';
  static String friendshipRequest = 'friendship_request';
  static String membershipRequestAccepted = 'membership_request_accepted';
  static String membershipRequestRejected = 'membership_request_rejected';
  static String newAtMention = 'new_at_mention';
  static String commentReply = 'comment_reply';
  static String newMembershipRequest = 'new_membership_request';
  static String groupInvite = 'group_invite';
  static String memberPromotedToAdmin = 'member_promoted_to_admin';
  static String updateReply = 'update_reply';
  static String actionActivityLiked = 'action_activity_liked';
  static String memberVerified = 'bp_verified_member_verified';
  static String memberUnverified = 'bp_verified_member_unverified';
  static String bbpNewReply = 'bbp_new_reply';
  static String socialVSharePost = 'socialv_share_post';
  static String actionActivityReacted = 'action_activity_reacted';
  static String actionCommentActivityReacted = 'action_comment_activity_reacted';
}

class MemberType {
  static String alphabetical = 'alphabetical';
  static String active = 'active';
  static String newest = 'newest';
  static String random = 'random';
  static String online = 'online';
  static String popular = 'popular';
  static String suggested = 'suggested';
}

class Friendship {
  static String following = language.unfriend.capitalizeFirstLetter();
  static String follow = language.addToFriend;
  static String requested = language.cancelRequest;

  static String currentUser = 'current_user';
  static String pending = 'pending'; // Requested
  static String notFriends = 'not_friends';
  static String awaitingResponse = 'awaiting_response'; // confirm / reject
  static String isFriend = 'is_friend';
}

class AccountType {
  static String public = 'public';
  static String private = 'private';
  static String hidden = 'hidden';
  static String privateGroup = 'Private Group';
}

class Component {
  static String groups = 'groups';
  static String activity = 'activity';
  static String friends = 'friends';
  static String blogs = 'blogs';
  static String members = 'members';
  static String activityLike = 'socialv_activity_like_notification';
  static String verifiedMember = 'bp_verified_member';
  static String forums = 'forums';
}

class Roles {
  static const admin = 'admin';
  static const member = 'member';
  static String mod = 'mod';
}

class MediaTypes {
  static String photo = 'photo';
  static String image = 'image';
  static String video = 'video';
  static String audio = 'audio';
  static String doc = 'doc';
  static String gif = 'gif';
  static String media = 'media';
  static String gallery = 'gallery';
  static String myGallery = 'my-gallery';
}

class GroupActions {
  static String demote = 'demote';
  static String promote = 'promote';
  static String ban = 'ban';
  static String unban = 'unban';
}

class PostActivityType {
  static String activityUpdate = 'activity_update';
  static String mppMediaUpload = 'mpp_media_upload';
  static String activityShare = 'activity_share';
  static String newBlogPost = 'new_blog_post';
}

class GroupRequestType {
  static const String all = 'all';
  static const String userGroup = 'user_groups';
  static const String suggestionGroup = 'suggestions';
}

class PostRequestType {
  static String newsFeed = 'newsfeed';
  static String timeline = 'timeline';
  static String group = 'groups';
  static String singleActivity = 'single-activity';
  static String favorites = 'favorites';
}

class FieldType {
  static String textBox = 'textbox';
  static String selectBox = 'selectbox';
  static String datebox = 'datebox';
  static String url = 'url';
  static String textarea = 'textarea';
  static String wpTextbox = 'wp-textbox';
}

class ProfileFields {
  static String birthDate = 'Birthdate';
  static String name = 'Name';
  static String socialNetworks = 'Social Networks';
}

class BlockUserKey {
  static String block = 'block';
  static String unblock = 'unblock';
}

class ProductTypes {
  static String simple = 'simple';
  static String grouped = 'grouped';
  static String variation = 'variation';
  static String variable = 'variable';
}

class StockStatus {
  static String inStock = 'instock';
}

class ProductFilters {
  static String clear = 'clear';
  static String date = 'date';
  static String price = 'price';
  static String popularity = 'popularity';
  static String rating = 'rating';
}

class OrderStatus {
  static String any = 'any';
  static String pending = 'pending';
  static String processing = 'processing';
  static String onHold = 'on-hold';
  static String completed = 'completed';
  static String cancelled = 'cancelled';
  static String refunded = 'refunded';
  static String failed = 'failed';
  static String trash = 'trash';
}

class ForumTypes {
  static String forum = 'forum';
  static String category = 'category';
}

class ProfileVisibilityTypes {
  static String staticSettings = 'static_settings';
  static String dynamicSettings = 'dynamic_settings';
}

class StoryHighlightOptions {
  static String draft = 'draft';
  static String trash = 'trash';
  static String delete = 'delete';
  static String publish = 'publish';
  static String category = 'category';
  static String story = 'story';
}

enum FileTypes { CANCEL, CAMERA, GALLERY, CAMERA_VIDEO }

class AppThemeMode {
  static const ThemeModeSystem = 0;
  static const ThemeModeLight = 1;
  static const ThemeModeDark = 2;
}

class VerificationStatus {
  static const pending = 'pending';
  static const accepted = 'accepted';
  static const rejected = 'rejected';
}

class CourseStatus {
  static const completed = 'completed';
  static const failed = 'failed';
  static const passed = 'passed';
  static const enrolled = 'enrolled';
  static const started = 'started';
  static const finished = 'finished';
  static const inProgress = 'in-progress';
}

class CourseType {
  static const lp_lesson = 'lp_lesson';
  static const lp_quiz = 'lp_quiz';
  static const evaluate_lesson = 'evaluate_lesson';
  static const evaluate_quiz = 'evaluate_quiz';
}

class QuestionType {
  static const single_choice = 'single_choice';
  static const true_or_false = 'true_or_false';
  static const fill_in_blanks = 'fill_in_blanks';
}

class FavouriteType {
  static const star = 'star';
  static const unStar = 'unstar';
}

class ThreadType {
  static const group = 'group';
  static const thread = 'thread';
}

class MessageText {
  static const onlyFiles = '<!-- BM-ONLY-FILES -->';
}

class SocketEvents {
  static const onlineUsers = 'onlineUsers';
  static const getUnread = 'getUnread';
  static const subscribeToThreads = 'subscribeToThreads';
  static const message = 'message';
  static const writing = 'writing';
  static const groupCallStatusesBulk = 'groupCallStatusesBulk';
  static const threadOpen = 'threadOpen';
  static const v3GetStatuses = '/v3/getStatuses';
  static const v3fastMsg = '/v3/fastMsg';
  static const delivered = 'delivered';
  static const tempId = 'tempId';
  static const seen = 'seen';
  static const threadInfoChanged = 'threadInfoChanged';
  static const userOffline = 'userOffline';
  static const userOnline = 'userOnline';
  static const v2MessageMetaUpdate = 'v2/messageMetaUpdate';
  static const messageDeleted = 'message_deleted';
  static const v2AbortFastMessage = '/v2/abortFastMessage';
  static const mediaEvent = 'mediaEvent';

  // sub events
  static const calling = 'calling';
  static const selfReject = 'self_reject';
  static const answered = 'answered';
  static const callEnd = 'call_end';
  static const rejected = 'rejected';
  static const callCancelled = 'call_cancelled';
}

class MessageUserSettings {
  static const chatBackground = 'chat_background';
  static const bmBlockedUsers = 'bm_blocked_users';
  static const notifications = 'notifications';
}

/// PaymentMethods
class PaymentMethods {
  static const card = 'card';
  static const upi = 'upi';
  static const netBanking = 'netbanking';
  static const paylater = 'paylater';
  static const inAppPayment = 'in-app';
}

class PaymentIds {
  static String stripe = 'stripe';
  static String razorpay = 'razorpay';
}

class BetterMessageCallType {
  static String audio = 'audio';
  static String video = 'video';
}

class TopicType {
  static String favorite = 'favorite';
  static String members = 'members';
  static String engagement = 'engagements';
  static String forums = 'forums';
}

enum SourceType { post, story }

const String freeSubscription = 'free';
