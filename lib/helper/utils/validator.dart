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
    return null;
  }

  static String? validateAuthFields(
      {required String? result, String? message = "Field can't be empty!"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    } else if (result.length < 3 || result.length > 30) {
      return "Limit (3-30)";
    }
    return null;
  }

  static String? validateTitle(
      {required String? result, String? message = "Field can't be empty!"}) {
    if (result == null) {
      return null;
    }

    if (result.isEmpty) {
      return message;
    } else if (result.length > 200) {
      return "Limit (0-200)";
    } else if (result.length < 5) {
      return "Atleast 5 characters needed";
    }
    return null;
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
    return null;
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
    return null;
  }
}
