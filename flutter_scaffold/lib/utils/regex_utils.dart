class RegexUtils {
  static const String regEmail = r'^\S+@\S+\.\S+$';

  static bool test(String regex, String input) {
    if (input == null || input.isEmpty) {
      return false;
    }

    return RegExp(regex).hasMatch(input);
  }

  /// 是否是有效的邮箱地址
  static bool isEmail(String email) {
    return test(regEmail, email);
  }
}
