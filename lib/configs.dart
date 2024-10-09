import 'package:country_picker/country_picker.dart';

/// App Name
const APP_NAME = "Elite Virtus";

/// App Icon src
const APP_ICON = "assets/app_icon.png";

/// Splash screen image src
const SPLASH_SCREEN_IMAGE = 'assets/images/splash_image.png';

/// NOTE: Do not add slash (/) or (https://) or (http://) at the end of your domain.
const WEB_SOCKET_DOMAIN = "elite-virtus.academy";

/// NOTE: Do not add slash (/) at the end of your domain.
const DOMAIN_URL = "https://elite-virtus.academy";

const BASE_URL = '$DOMAIN_URL/wp-json/';

/// AppStore Url
const IOS_APP_LINK = '';

/// Terms and Conditions URL
const TERMS_AND_CONDITIONS_URL = '$DOMAIN_URL/terms-condition/';

/// Privacy Policy URL
const PRIVACY_POLICY_URL = '$DOMAIN_URL/privacy-policy-2/';

/// Support URL
const SUPPORT_URL = '';

/// AdMod Id
// Android
const mAdMobAppId = '';
const mAdMobBannerId = '';

// iOS
const mAdMobAppIdIOS = '';
const mAdMobBannerIdIOS = '';

const mTestAdMobBannerId = '';

/// Woo Commerce keys

//live
const CONSUMER_KEY = 'ck_3d5a0ff7ed8e800611ffe4a3b340696a26c8eff0';
const CONSUMER_SECRET = 'cs_07c3a904288d5532c3c94c9d3f5cdd73338789e4';


/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'AT';
const STRIPE_CURRENCY_CODE = 'EUR';

/// RAZORPAY PAYMENT DETAIL
const RAZORPAY_CURRENCY_CODE = 'EUR';

/// AGORA
const AGORA_APP_ID = '';

Country defaultCountry() {
  return Country(
    phoneCode: '43',
    countryCode: 'AT',
    e164Sc: 43,
    geographic: true,
    level: 1,
    name: 'Austria',
    example: '+4323456789',
    displayName: 'Austria (AT) [+43]',
    displayNameNoCountryCode: 'Austria (AT)',
    e164Key: '43-IN-0',
    fullExampleWithPlusSign: '+436123456789',
  );
}

// endregion
