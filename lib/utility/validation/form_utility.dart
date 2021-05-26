class FormUtility {
  static String onSaved(String value, String label) {
    if (label.isNotEmpty) {
      if (label == "FirstName") {
        return value;
      } else if (label == "LastName") {
        return value;
      } else if (label == "Email") {
        return value;
      } else if (label == "Password") {
        return value;
      } else if (label == "I am") {
        return value;
      } else if (label == "Phone") {
        return value;
      }
    } else {
      // Should not be here
    }
  }

  static String _fieldValidator(String value, String label) {
    if (value == null || value.isEmpty) {
      if (label == 'FirstName') {
        return "First Name is mandatory.";
      } else if (label == 'LastName') {
        return "Last Name is mandatory.";
      } else if (label == 'Email') {
        return "Email is mandatory.";
      } else if (label == 'Password') {
        return "Password is mandatory.";
      } else if (label == 'Confirm Password') {
        return "Confirm Password is mandatory.";
      } else if (label == 'I am') {
        return "Your role ia mandatory.";
      } else if (label == 'Phone') {
        return "Phonenumber ia mandatory.";
      }
    } else {
      if (label == 'Email') {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (!emailValid) {
          return 'The Email address is badly formatted';
        }
      } else if (label == 'Confirm Password') {
        
      } else if (label == 'Password') {
        
      }
    }
    return null;
  }
}
