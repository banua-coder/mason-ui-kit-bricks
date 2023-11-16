# 0.4.0

- Added support for flutter 3.13.
- Update some packages.
- Add check for `flutter version management` for running flutter/dart related commmands in the hooks.
- Fix some bugs and minor errors after generating code.

# 0.3.0+3

- Added a check for enum property in pre-gen hooks. If there are no enums and hasEnum is set to true, prompt the user for the enums value.

# 0.2.0+2

- Improved prompts during component generation:
  - Added prompt for the number of properties to be generated.
  - Added prompt for the number of enums to be generated (if the component has enums).
  - Prompt users to provide information about each property and enum item.
- Renamed the example config files to `config.json` and removed the unnecessary `example` prefix.
- Added a new `component-config.json` file that users can use to generate components using the UI Kit component brick with the command `mason make ui_kit_component -c component-config.json`. Users can customize the content of `component-config.json` according to their needs.
- Implemented a post-generation process to fix code violations using `dart fix --apply`.
- Added a final congratulatory message when the component is generated successfully.

# 0.1.0+1

- Initial release of ui_kit_component brick.
