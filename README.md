# Layrz Theme

Managed by <b>Golden M, Inc.</b> with authorization of <b>Layrz Limited</b>

## Important notice about Flutter 3.22.0 support (2024-05-15)
Due to a incompatibility with `permission_handler_html`, `layrz_theme` cannot compile in WASM, however, you can define this override in your package to avoid this issue:
```yaml
permission_handler_html: # Added this override to support WASM
    git:
      url: https://github.com/raldhafiri/flutter-permission-handler.git
      ref: main
      path: permission_handler_html
```

## Description
It's a set of tools, widgets and generators to help you to create an application easily, fast and with a good quality using the Layrz design standard. Works in the platforms that Flutter supports, also mostly of `layrz_theme` works in Embedded devices using [Flutter eLinux](https://github.com/sony/flutter-elinux) (Disclaimer, not fully tested).

## This library is a framework?
Technically, no because Flutter is the Framework, but `layrz_theme` is framework-like library, with a set of tools, widgets and generators.

## Why this library exists?
We are using Flutter to create most of our applications, based on that, we create initially `layrz_theme` to standarize the design of our applications, but we think that it could be useful for other developers, so we decided to share it with the community.

## Do you have other libraries?
Of course! We have multiple libraries (for Layrz or general purpose) that you can use in your projects, you can find us on [PyPi](https://pypi.org/user/goldenm/) for Python libraries, [RubyGems](https://rubygems.org/profiles/goldenm) for Ruby gems, [NPM of Golden M](https://www.npmjs.com/~goldenm) or [NPM of Layrz](https://www.npmjs.com/~layrz-software) for NodeJS libraries or here in [Pub.dev](https://pub.dev/publishers/goldenm.com/packages) for Dart/Flutter libraries.

## How can I get support if I have a problem?
Usually our inline documentation helps you to understand how to use our libraries, but if you have a problem, you can create an Issue in our [Repository](https://github.com/goldenm-software/layrz_theme) or contact us at [support@goldenm.com](mailto:support@goldenm.com)

## I need to pay for this library?
<b>No!</b> This library is free and open source, you can use it in your projects without any cost, but if you want to support us, give us a thumbs up here in `pub.dev`!

## How can I contribute?
Feel free to create a Pull Request on our [Repository](https://github.com/goldenm-software/layrz_theme) or create an Issue if you find a bug or have a suggestion.

## Who are you?
<b>Golden M</b> is a software/hardware development company what is working on a new, innovative and disruptive technologies. For more information, contact us at [sales@goldenm.com](mailto:sales@goldenm.com)

## License
This project is under <b>MIT License</b>, for more information, check out the `LICENCE`
