class Validator {
  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Please enter a valid Email';
    }

    return null;
  }

  static String? validateTextField(
      {required String? result, String? message = "Field can't be empty!"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    }
  }

  static String? validateTitle(
      {required String? result, String? message = "Field can't be empty!"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    } else if (result.length > 200) {
      return "Limit of characters 0-200";
    }
  }

  static String? validatePassword(
      {required String? result, String? message = "Password can't be empty"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    }
    if (result.length < 6) {
      return "Password must be at-least than 6 characters long!";
    }
  }

  static String? validateNumberField(
      {required String? result,
      bool isDecimal = false,
      String? message = "Check entered value!"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    }

    try {
      switch (isDecimal) {
        case true:
          {
            double.parse(result);
            break;
          }
        case false:
          {
            int.parse(result);
            break;
          }
      }
    } catch (e) {
      return "Enter a proper value!";
    }
  }
}
