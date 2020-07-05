class AppStrings {
  /// App-wide strings
  static const appTitle = 'BIKE KOLLECTIVE';

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
}
