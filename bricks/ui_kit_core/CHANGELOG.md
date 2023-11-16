# 0.5.0

- Added support for flutter 3.13.
- Update some packages.
- Add check for `flutter version management` for running flutter/dart related commmands in the hooks.
- Replace my personal `analysis_options.yaml` with `very_good_analysis`
- Add very good `github` templates and `workflows`
- Add `component_x.dart` whcih add `skeletonize()` extension method to skeletonize a widget/component.

# 0.4.0+4

- Added a prompt for users to select whether they want to use a custom text theme or the default text theme from the selected font family.
- Added darkTextTheme.

# 0.3.0+3

- Improved prompts during skeleton generation:
  - Added prompt for the number of colors to be generated.
  - Added prompt for the number of text styles to be generated.
  - Prompt users to provide information about each color and text style item.
- Fixed an issue with the `change_app_package_name` process, which was not updating the app package name and bundle id correctly.
- Renamed the example config files to `config.json` and removed the unnecessary `example` prefix.
- Added a new `component-config.json` file that users can use to generate components using the UI Kit component brick with the command `mason make ui_kit_component -c component-config.json`. Users can customize the content of `component-config.json` according to their needs.
- Implemented a post-generation process to fix code violations using `dart fix --apply`.
- Added a final congratulatory message when the component is generated successfully.

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

# 0.1.0+1

- Initial release of ui_kit_core brick.
