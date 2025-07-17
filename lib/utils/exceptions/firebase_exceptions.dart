/// Custom exception class to handle various Firebase errors.
class FirebaseException implements Exception {
  /// The error code associated with the exception.
  final String code;

  /// Constructor that takes an error code.
  FirebaseException(this.code);

  /// Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'The email address is already registered. Please use a different email.';
      case 'invalid-email':
        return 'The email address provided is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support for assistance.';
      case 'user-not-found':
        return 'Invalid login details. User not found.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please enter a valid code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please request a new verification code.';
      case 'quota-exceeded':
        return 'Quota exceeded. Please try again later.';
      case 'email-already-exists':
        return 'The email address already exists. Please use a different email.';
      case 'provider-already-linked':
        return 'The account is already linked with another provider.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please log in again.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account.';
      case 'user-mismatch':
        return 'The supplied credentials do not correspond to the previously signed in user.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'expired-action-code':
        return 'The action code has expired. Please request a new one.';
      case 'invalid-action-code':
        return 'The action code is invalid. This can happen if the code is malformed or has already been used.';
      case 'missing-action-code':
        return 'The action code is missing.';
      case 'user-token-expired':
        return 'The user token has expired, and authentication is required. Please sign in again.';
      case 'invalid-user-token':
        return 'The user token is not valid.';
      case 'token-expired':
        return 'The token has expired. Please sign in again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-api-key':
        return 'The API key provided is invalid.';
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your internet connection and try again.';
      case 'internal-error':
        return 'An internal error occurred. Please try again later.';
      case 'invalid-custom-token':
        return 'The custom token format is incorrect or the token is invalid.';
      case 'custom-token-mismatch':
        return 'The custom token corresponds to a different Firebase project.';
      case 'invalid-credential':
        return 'The supplied auth credential is malformed or has expired.';
      case 'invalid-phone-number':
        return 'The phone number provided is invalid.';
      case 'missing-phone-number':
        return 'The phone number is missing.';
      case 'invalid-recipient-email':
        return 'The recipient email is invalid.';
      case 'invalid-sender':
        return 'The sender email is invalid.';
      case 'invalid-message-payload':
        return 'The message payload is invalid.';
      case 'invalid-continue-uri':
        return 'The continue URL provided is invalid.';
      case 'missing-continue-uri':
        return 'A continue URL must be provided in the request.';
      case 'missing-email':
        return 'An email address must be provided.';
      case 'missing-password':
        return 'A password must be provided.';
      case 'captcha-check-failed':
        return 'The reCAPTCHA verification failed. Please try again.';
      case 'invalid-app-credential':
        return 'The phone verification request contains an invalid application verifier.';
      case 'invalid-app-id':
        return 'The mobile app identifier is not registered for the current project.';
      case 'session-cookie-expired':
        return 'The Firebase session cookie has expired. Please sign in again.';
      case 'uid-already-exists':
        return 'The provided user ID is already in use by another user.';
      case 'web-storage-unsupported':
        return 'Web storage is not supported or is disabled.';
      case 'app-deleted':
        return 'This instance of Firebase App has been deleted.';
      case 'keychain-error':
        return 'An error occurred while accessing the keychain.';
      case 'multi-factor-auth-required':
        return 'Multi-factor authentication is required to complete this operation.';
      case 'multi-factor-info-not-found':
        return 'The multi-factor info was not found.';
      case 'admin-restricted-operation':
        return 'This operation is restricted to administrators only.';
      case 'unverified-email':
        return 'The email address is not verified. Please verify your email and try again.';
      case 'second-factor-already-in-use':
        return 'The second factor is already enrolled on this account.';
      case 'maximum-second-factor-count-exceeded':
        return 'The maximum allowed number of second factors on a user has been exceeded.';
      case 'tenant-id-mismatch':
        return 'The tenant ID does not match the Auth instance\'s tenant ID.';
      case 'unsupported-tenant-operation':
        return 'This operation is not supported in a multi-tenant context.';
      case 'invalid-dynamic-link-domain':
        return 'The provided dynamic link domain is not configured or authorized.';
      case 'rejected-credential':
        return 'The request contains malformed or mismatching credentials.';
      case 'phone-number-already-exists':
        return 'The provided phone number is already in use by an existing user.';
      case 'invalid-tenant-id':
        return 'The tenant ID provided is invalid.';
      case 'missing-multi-factor-info':
        return 'No multi-factor info was found for this user.';
      case 'missing-multi-factor-session':
        return 'The multi-factor session is missing.';
      case 'invalid-multi-factor-session':
        return 'The multi-factor session is invalid.';
      case 'user-cancelled':
        return 'The user cancelled the operation.';
      case 'timeout':
        return 'The operation timed out. Please try again.';
      default:
        return 'An unexpected Firebase error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'FirebaseException: $message (code: $code)';
}