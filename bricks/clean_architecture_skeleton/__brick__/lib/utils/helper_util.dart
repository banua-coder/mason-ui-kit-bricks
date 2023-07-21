class HelperUtil {
  const HelperUtil._();

  static const HelperUtil _instance = HelperUtil._();

  factory HelperUtil() {
    return _instance;
  }

  static String getAvatarUrl({
    String? avatar,
    required String name,
    String bgColor = '054A80',
    String textColor = 'FFFFFF',
  }) {
    if (avatar != null && avatar.isNotEmpty && !avatar.contains('ui-avatars')) {
      return avatar;
    }

    var uri = Uri(
      scheme: 'https',
      host: 'ui-avatars.com',
      path: 'api/',
      queryParameters: {
        'name': name,
        'size': '256',
        'color': textColor,
        'background': bgColor,
      },
    );

    return uri.toString();
  }
}
