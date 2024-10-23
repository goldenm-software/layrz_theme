part of '../helpers.dart';

/// [drawAvatar] is a helper function to generate a [CircleAvatar] using the avatar and the name
/// (as failover) of the entity.
///
/// The priority order of each property is:
/// 1. [dynamicAvatar]
/// 2. [avatar]
/// 3. [icon]
/// 4. [name]
///
/// [dynamicAvatar] is the new avatar engine, can be nullable.
/// Prevent submit [avatar] and [icon] if you are using this.
/// Nothing will happend but is less code to you :)
/// [avatar] is the avatar of the user. Can be nullable
/// [icon] is the icon of the user. Can be nullable
/// [name] is the name of the user. Can be nullable
/// [size] is the size of the avatar.
/// By default, it is 30.
/// You can control the radius using [radius] property
/// By default, it is 30. (The same as the [size])
/// [color] is the color of the avatar. By default, it is [Theme.of(context).primaryColor].
/// Only when [dynamicAvatar] is not null, the default value of the color is based on the different types of avatars.
/// For [AvatarType.emoji], the default color is [Colors.grey.shade900].
/// For [AvatarType.icon], the default color is [Theme.of(context).primaryColor].
/// For [AvatarType.base64] and [AvatarType.url], the default color is [Colors.transparent].
/// For [AvatarType.none], the default color is [Theme.of(context).primaryColor].
/// [elevation] is the elevation of the avatar. By default, it is 1.
/// The [shadowColor] is the color of the [BoxShadow], by default it is [Colors.black.withOpacity(0.2)].
/// The [reverse] is the boolean to reverse shadow of the [BoxDecoration], by default it is false.
/// [context] is the context of the widget.
@Deprecated(
  'This utility function will be deleted at version 8.0.0 and will be replaced by the widget `ThemedAvatar` - '
  'Use the widget `ThemedAvatar` instead',
)
Widget drawAvatar({
  Avatar? dynamicAvatar,
  String? avatar,
  IconData? icon,
  String? name,
  double size = 30,
  double radius = 30,
  Color? color,
  double elevation = 1,
  Color? shadowColor,
  bool reverse = false,
  required BuildContext context,
}) {
  return ThemedAvatar(
    dynamicAvatar: dynamicAvatar,
    avatar: avatar,
    icon: icon,
    name: name,
    size: size,
    radius: radius,
    color: color,
    elevation: elevation,
    shadowColor: shadowColor,
    reverse: reverse,
  );
}

class ThemedAvatar extends StatelessWidget {
  final Avatar? dynamicAvatar;
  final String? avatar;
  final IconData? icon;
  final String? name;
  final double size;
  final double radius;
  final Color? color;
  final double elevation;
  final Color? shadowColor;
  final bool reverse;

  const ThemedAvatar({
    super.key,

    /// [dynamicAvatar] is the new avatar engine, can be nullable.
    this.dynamicAvatar,

    /// [avatar] is the avatar of the user. Can be nullable
    ///
    /// Prevent submit [avatar] and [icon] if you are using this.
    /// Nothing will happend but is less code to you :)
    this.avatar,

    /// [icon] is the icon of the user. Can be nullable
    ///
    /// Prevent submit [avatar] and [icon] if you are using this.
    /// Nothing will happend but is less code to you :)
    this.icon,

    /// [name] is the name of the user. Can be nullable
    this.name,

    /// [size] is the size of the avatar.
    /// By default, it is 30.
    this.size = 30,

    /// You can control the radius using [radius] property
    /// By default, it is 30. (The same as the [size])
    this.radius = 10,

    /// [color] is the color of the avatar. By default, it is [Theme.of(context).primaryColor].
    /// Only when [dynamicAvatar] is not null, the default value of the color is based on the
    /// different types of avatars.
    /// For [AvatarType.emoji], the default color is [Colors.grey.shade900].
    /// For [AvatarType.icon], the default color is [Theme.of(context).primaryColor].
    /// For [AvatarType.base64] and [AvatarType.url], the default color is [Colors.transparent].
    /// For [AvatarType.none], the default color is [Theme.of(context).primaryColor].
    this.color,

    /// [elevation] is the elevation of the avatar. By default, it is 1.
    this.elevation = 1,

    /// The [shadowColor] is the color of the [BoxShadow], by default it is [Colors.black.withOpacity(0.2)].
    this.shadowColor,

    /// The [reverse] is the boolean to reverse shadow of the [BoxDecoration], by default it is false.
    this.reverse = false,
  })  : assert(elevation <= 5, 'The elevation must be less than or equal to 5'),
        assert(elevation >= 0, 'The elevation must be greater than or equal to 0'),
        assert(radius >= 0, 'The radius must be greater than or equal to 0');

  @override
  Widget build(BuildContext context) {
    Color baseColor = color ?? Theme.of(context).primaryColor;
    Color baseShadow = shadowColor ?? Colors.black.withOpacity(0.2);

    if (dynamicAvatar != null) {
      return _renderDynamicAvatar(
        avatar: dynamicAvatar!,
        context: context,
        name: name ?? 'N/A',
        elevation: elevation,
        shadowColor: baseShadow,
        reverse: reverse,
        size: size,
        radius: radius,
        color: baseColor,
      );
    }

    if (avatar?.isNotEmpty ?? false) {
      return _renderImage(
        image: avatar!,
        context: context,
        name: name ?? 'N/A',
        elevation: elevation,
        shadowColor: baseShadow,
        reverse: reverse,
        size: size,
        radius: radius,
        color: baseColor,
      );
    }

    if (icon != null) {
      return _renderIcon(
        icon: icon!,
        context: context,
        name: name ?? 'N/A',
        elevation: elevation,
        shadowColor: baseShadow,
        reverse: reverse,
        size: size,
        radius: radius,
        color: baseColor,
      );
    }

    return _generateDeafult(
      context: context,
      name: name ?? 'N/A',
      elevation: elevation,
      shadowColor: baseShadow,
      reverse: reverse,
      size: size,
      radius: radius,
      color: baseColor,
    );
  }

  Widget loadingProgressIndicator(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).dividerColor,
          backgroundColor: Colors.transparent,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _renderImage({
    required String image,
    required BuildContext context,
    required String name,
    required double elevation,
    required Color shadowColor,
    required bool reverse,
    required double size,
    required double radius,
    required Color color,
  }) {
    if (image.isEmpty) {
      return _generateDeafult(
        context: context,
        elevation: elevation,
        shadowColor: shadowColor,
        reverse: reverse,
        color: color,
        size: size,
        radius: radius,
        name: name,
      );
    }

    return _generateCircle(
      context: context,
      elevation: elevation,
      shadowColor: shadowColor,
      reverse: reverse,
      color: color,
      size: size,
      radius: radius,
      child: ThemedImage(
        path: image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderIcon({
    required IconData icon,
    required BuildContext context,
    required String name,
    required double elevation,
    required Color shadowColor,
    required bool reverse,
    required double size,
    required double radius,
    required Color color,
  }) {
    return _generateCircle(
      context: context,
      elevation: elevation,
      shadowColor: shadowColor,
      reverse: reverse,
      color: color,
      size: size,
      radius: radius,
      child: Icon(
        icon,
        color: validateColor(color: color),
        size: size * 0.7,
      ),
    );
  }

  Widget _renderDynamicAvatar({
    required Avatar avatar,
    required BuildContext context,
    required String name,
    required double elevation,
    required Color shadowColor,
    required bool reverse,
    required double size,
    required double radius,
    required Color color,
  }) {
    switch (avatar.type) {
      case AvatarType.emoji:
        return _generateCircle(
          context: context,
          elevation: elevation,
          shadowColor: shadowColor,
          reverse: reverse,
          color: Colors.white,
          size: size,
          radius: radius,
          child: Text(
            avatar.emoji ?? _cleanName(name),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: size * 0.6),
          ),
        );
      case AvatarType.icon:
        return _renderIcon(
          icon: avatar.icon ?? Icons.person,
          context: context,
          name: name,
          elevation: elevation,
          shadowColor: shadowColor,
          reverse: reverse,
          size: size,
          radius: radius,
          color: color,
        );

      case AvatarType.base64:
        return _renderImage(
          image: avatar.base64 ?? '',
          context: context,
          name: name,
          elevation: elevation,
          shadowColor: shadowColor,
          reverse: reverse,
          size: size,
          radius: radius,
          color: color,
        );

      case AvatarType.url:
        return _renderImage(
          image: avatar.url ?? '',
          context: context,
          name: name,
          elevation: elevation,
          shadowColor: shadowColor,
          reverse: reverse,
          size: size,
          radius: radius,
          color: color,
        );

      default:
        return _generateDeafult(
          context: context,
          elevation: elevation,
          shadowColor: shadowColor,
          reverse: reverse,
          color: color,
          size: size,
          radius: radius,
          name: name,
        );
    }
  }

  Widget _generateDeafult({
    required BuildContext context,
    required String name,
    required double elevation,
    required Color shadowColor,
    required bool reverse,
    required double size,
    required double radius,
    required Color color,
  }) {
    return _generateCircle(
      context: context,
      elevation: elevation,
      shadowColor: shadowColor,
      reverse: reverse,
      color: color,
      size: size,
      radius: radius,
      child: Center(
        child: Text(
          _cleanName(name),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: validateColor(color: color),
                fontSize: size * 0.4,
              ),
        ),
      ),
    );
  }

  Widget _generateCircle({
    required Widget child,
    required BuildContext context,
    required double elevation,
    required Color shadowColor,
    required bool reverse,
    required double size,
    required double radius,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: generateContainerElevation(
        context: context,
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        reverse: reverse,
        radius: radius,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  String _cleanName(String? raw) {
    if (raw == null) return 'NA';
    String output = raw.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (output.isEmpty) return 'NA';
    if (output.length < 2) return output.toLowerCase();
    return output.substring(0, 2).toUpperCase();
  }
}
