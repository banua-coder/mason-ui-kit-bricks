# Mason UI Kit Bricks

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/banua-coder/mason-ui-kit-bricks/blob/main/LICENSE)

This repository contains a collection of Mason bricks for building Flutter projects using the Clean Architecture approach and UI Kit components.

## Bricks

### Clean Architecture Skeleton

The `clean_architecture_skeleton` brick sets up the foundation for a Flutter project following the Clean Architecture pattern. It provides the necessary directories, files, and configurations to kickstart your project development with a clean, organized, and scalable architecture.

#### Features

- Clean Architecture folder structure.
- Separation of concerns with presentation, domain, and data layers.
- Configurable environment setup.

#### How to Use

To create a new Flutter project with the Clean Architecture structure, run the following command:

```bash
mason make clean_architecture_skeleton
```

Follow the prompts to customize the project's name and organization.

### UI Kit Core

The `ui_kit_core` brick is used for generating the skeleton or core of a UI Kit package. It provides essential base classes, utilities, and configurations to streamline the development process and ensure consistency across components.

#### Features

- Base classes for creating UI Kit components.
- Color and text style configurations for consistent theming.
- Helper methods for common UI patterns.
- Pre-configured code templates for faster development.

#### How to Use

To generate the core of your UI Kit package, run the following command:

```bash
mason make ui_kit_core
```

### UI Kit Component

The `ui_kit_component` brick is a specialized brick for generating fully customizable UI components following the Clean Architecture principles. It utilizes the functionalities provided by `ui_kit_core` to promote reusability and modularization, allowing you to build sophisticated UI components with ease.

#### Features

- Generates Clean Architecture-based UI components.
- Provides prompts for customizing the component's properties and enums.
- Automatic generation of boilerplate code for the UI component.

#### How to Use

To generate a new UI component using the `ui_kit_component` brick, run the following command:

```bash
mason make ui_kit_component
```

Follow the prompts to customize the component's properties and enums to suit your needs.

## License

This repository is licensed under the MIT License. Feel free to use, modify, and distribute the code as per the license terms.

## Contributing

We welcome contributions to improve and extend the Mason UI Kit Bricks. If you have any ideas, bug fixes, or feature requests, please submit a pull request or open an issue on GitHub.

Thank you for using Mason UI Kit Bricks! Happy coding!
