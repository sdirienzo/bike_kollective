import 'package:bike_kollective/screens/bike_details_screen.dart';

class AppStrings {
  /// App-wide strings
  static const appTitle = 'BIKE KOLLECTIVE';

  /// Firebase DB Bikes strings
  static const bikeCollectionKey = 'bikes';
  static const bikeCheckedOutKey = 'checkedOut';
  static const bikeCombinationKey = 'combination';
  static const bikeImageKey = 'image';
  static const bikeLatitudeKey = 'latitude';
  static const bikeLongitudeKey = 'longitude';
  static const bikeSizeKey = 'size';
  static const bikeTypeKey = 'type';
  static const bikeRatingKey = 'rating';

  /// Firebase DB Rides strings
  static const rideCollectionKey = 'rides';
  static const rideUserIdKey = 'userId';
  static const rideBikeIdKey = 'bikeId';
  static const rideStartTimeKey = 'startTime';
  static const rideEndTimeKey = 'endTime';

  /// Firebase DB Users strings
  static const userCollectionKey = 'users';
  static const userEmailKey = 'email';
  static const userActiveRideKey = 'activeRide';
  static const userAccountDisabledKey = 'accountDisabled';

  /// AppDrawer/Sidebar strings
  static const appDrawerBikesLabel = 'Bikes';
  static const appDrawerAddBikeLabel = 'Add Bike';
  static const appDrawerLogoutLabel = 'Log Out';

  /// Login and Register screen common strings
  static const emailFieldLabel = 'Email';
  static const emailFieldHint = 'Please enter an email address';
  static const passwordFieldLabel = 'Password';
  static const passwordFieldHint = 'Please enter a password';

  /// Login and Register common error codes
  static const invalidEmailErrorCode = 'ERROR_INVALID_EMAIL';
  static const operationNotAllowedErrorCode = 'ERROR_OPERATION_NOT_ALLOWED';

  /// Login and Register common error messages
  static const unexpectedErrorMessage =
      'An unexpected error occurred.  Please try again';

  /// Login screen strings
  static const legalMessage =
      'By continuing, I confirm that I am 18+, and agree to the Bike Kollective\'s Terms of Use and Accident Policy';
  static const loginButtonLabel = 'Login';

  /// Login error codes
  static const wrongPasswordErrorCode = 'ERROR_WRONG_PASSWORD';
  static const noUserErrorCode = 'ERROR_USER_NOT_FOUND';
  static const disabledUserErrorCode = 'ERROR_USER_DISABLED';
  static const tooManyRequestErrorCode = 'ERROR_TOO_MANY_REQUESTS';

  /// Login error messages
  static const loginErrorMessage =
      'Invalid email and/or password.  Please try again';

  /// Register screen strings
  static const registerButtonLabel = 'Create an Account';

  /// Register error codes
  static const weakPasswordErrorCode = 'ERROR_WEAK_PASSWORD';
  static const emailInUseErrorCode = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const invalidCredentialErrorCode = 'ERROR_INVALID_CREDENTIAL';

  /// Register error messages
  static const invalidEmailErrorMessage = 'Invalid email.  Please try again';
  static const weakPasswordErrorMessage =
      'Password is too weak.  Please try again';
  static const emailInUseErrorMessage =
      'Email is already in use.  Please try again';

  /// Location Request screen strings
  static const locationOffMessage = 'Location services are off';
  static const locationOffDetails =
      'Turn on location services to search for bikes near you';
  static const turnOnLocationButtonLabel = 'TURN ON';

  /// Bike Details screen strings
  static const bikeDetailsScreenTitle = 'BIKE DETAILS';
  static const checkoutButtonLabel = 'Check Out';

  /// Check Out error messages
  static const bikeCheckedOutErrorMessage =
      'Bike is already checked out.  Please try a different bike';
  static const bikeTooFarAwaryErrorMessage =
      'You must be within ${BikeDetailsScreen.maxDistanceInMeters} meters of a bike to check it out';
}
