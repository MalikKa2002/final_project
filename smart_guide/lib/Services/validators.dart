class Validators {
  // College Name Validation
  static String? validateCollegeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "College name is required";
    }
    String pattern = r'^[a-zA-Z\s]{3,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter a valid college name (letters only, at least 3 characters)";
    }
    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Standard email regex
    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  // Phone Number Validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    String pattern = r'^\+?\d{7,15}$'; // Allows optional + and 7-15 digits
    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  // Website Validation
  static String? validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Website URL is required";
    }
    String pattern =
        r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter a valid website URL";
    }
    return null;
  }

// Location Validation
  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Location is required";
    }
    String pattern = r'^[a-zA-Z\s,]{3,}$'; // Allows letters, spaces, and commas
    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter a valid location (letters & commas only)";
    }
    return null;
  }

  // Description Validation
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required";
    }
    if (value.length < 200) {
      return "Description should be at least 10 characters long";
    }
    return null;
  }

  static String? validateUsernameAndPassword(
      String? username, String? password) {
    if (username == null ||
        username.trim().isEmpty ||
        password == null ||
        password.trim().isEmpty) {
      return "Username and password are required.";
    }

    // Example pattern: at least 3 characters, letters or numbers (customize as needed)
    String usernamePattern = r'^[a-zA-Z0-9]{3,}$';
    String passwordPattern = r'^.{6,}$'; // at least 6 characters

    bool isUsernameValid = RegExp(usernamePattern).hasMatch(username);
    bool isPasswordValid = RegExp(passwordPattern).hasMatch(password);

    if (!isUsernameValid || !isPasswordValid) {
      return "One or more fields are not correct.";
    }

    return null; // Everything is valid
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9]{3,}$').hasMatch(value)) {
      return 'Enter a valid username (min 3 letters/numbers)';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
