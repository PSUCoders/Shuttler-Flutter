/// SHUTTLE STOPS ///
enum ShuttleStop {
  Campus,
  Walmart,
  Target,
  Market32,
  Jade,
}

enum PrefsKey {
  NOTIFICATION_ON,
  SHUTTLE_STOP,
  EMAIL,
  IS_SIGN_IN,

  /// List of read notification ids
  SEEN_NOTIFICATION
}

class ErrorMessages {
  static String get wrongEmail => "Please provide a SUNY Plattsburgh email";

  static String get wrongDriverPassword =>
      "Please provide a correct driver password";
}

final String kVerificationScreenMessage = """
Please check your email for a sign in link.
Time to receive the email depends on your internet connection.
Check your Spam mailbox if you don't see the email.
""";

final String kDriverHomeMessage = """
Dear driver, 
please switch tracking on if you are on duty.

Dont' forget to switch tracking off when your are out of duty.
""";
