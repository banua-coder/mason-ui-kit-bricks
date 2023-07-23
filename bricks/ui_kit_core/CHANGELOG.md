# 0.1.0+1

- Initial release of ui_kit_core brick.

# 0.2.0+2

- Remove [`dart_code_metrics`](https://pub.dev/packages/dart_code_metrics) as it discontinued by the maintainer.
- Add [change_app_package_name](https://pub.dev/packages/change_app_package_name) to update example app bundle id.
- Replace [shimmer](https://pub.dev/packages/shimmer) with [skeletonizer](https://pub.dev/packages/skeletonizer)
- Add `pre_gen` hooks to remove `test/app_name_ui_kit_test.dart` flle.
- Add `post_gen` hooks to do some task automatically after the code generated successfully.
  - Fix `example` project by running `flutter create .` command inside `example` directory.
  - Install & upgrade all example project package.
  - Update bundle id to `com.app_name_ui_kit.example.app`
  - Check if `rename` package is installed. If not, then it will run `dart pub global activate rename`
  - Run `rename` to update app name to "App Name UI Kit".
  - Remove all unused files.
