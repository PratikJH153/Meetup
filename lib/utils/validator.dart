class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validateInterests({required String? interestText}) {
    if (interestText == null) {
      return null;
    }

    if (interestText.trim().isEmpty) {
      return 'Enter at-least one interest';
    }

    return null;
  }

  static String? validateBio({required String? Bio}) {
    if (Bio == null) {
      return null;
    }

    if (Bio.trim().isEmpty) {
      return 'Kindly add a bio';
    }

    return null;
  }

  static String? validateGender({required String? genderText}) {
    if (genderText == null) {
      return null;
    }

    if (genderText.trim().isEmpty) {
      return 'Specify your Gender!';
    }

    return null;
  }
  static String? validateAge({required String? ageText}) {
    if (ageText == null) {
      return null;
    }

    if (ageText.trim().isEmpty) {
      return 'Enter your age!';
    }

    return null;
  }
}
