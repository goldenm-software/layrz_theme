part of '../helpers.dart';

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
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final VoidCallback? onSecondaryTap;
  final double? iconSize;

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

    /// The [shadowColor] is the color of the [BoxShadow], by default it is [Colors.black.withValues(alpha:0.2)].
    this.shadowColor,

    /// The [reverse] is the boolean to reverse shadow of the [BoxDecoration], by default it is false.
    this.reverse = false,

    /// [onTap] is the callback to be executed when the avatar is tapped.
    ///
    /// Note: The tap effect is only available when is not rendering an image.
    this.onTap,

    /// [onLongTap] is the callback to be executed when the avatar is long tapped.
    ///
    /// Note: The tap effect is only available when is not rendering an image.
    this.onLongTap,

    /// [onSecondaryTap] is the callback to be executed when the avatar is secondary tapped.
    ///
    /// Note: The tap effect is only available when is not rendering an image.
    this.onSecondaryTap,

    /// [iconSize] is the size of the icon, by default it is a 70% of the [size].
    ///
    /// If you set this value, it will override the default size of the icon.
    this.iconSize,
  }) : assert(elevation <= 5, 'The elevation must be less than or equal to 5'),
       assert(elevation >= 0, 'The elevation must be greater than or equal to 0'),
       assert(radius >= 0, 'The radius must be greater than or equal to 0');

  @override
  Widget build(BuildContext context) {
    Color baseColor = color ?? Theme.of(context).primaryColor;
    Color baseShadow = shadowColor ?? Colors.black.withValues(alpha: 0.2);

    if (dynamicAvatar != null) {
      return _renderDynamicAvatar(
        onTap: onTap,
        onLongTap: onLongTap,
        onSecondaryTap: onSecondaryTap,
        avatar: dynamicAvatar!,
        context: context,
        name: name ?? 'N/A',
        elevation: elevation,
        shadowColor: baseShadow,
        reverse: reverse,
        size: size,
        radius: radius,
        color: color ?? baseColor,
      );
    }

    if (avatar?.isNotEmpty ?? false) {
      return _renderImage(
        context: context,
        shadowColor: baseShadow,
        color: baseColor,
        image: avatar ?? '',
      );
    }

    if (icon != null) {
      return _renderIcon(
        context: context,
        shadowColor: baseShadow,
        color: baseColor,
      );
    }

    return _generateDefault(
      context: context,
      shadowColor: baseShadow,
      color: baseColor,
    );
  }

  Widget _renderImage({
    required BuildContext context,
    required Color color,
    required Color shadowColor,
    required String image,
  }) {
    if (image.isEmpty) {
      return _generateDefault(context: context, shadowColor: shadowColor, color: color);
    }

    return _generateCircle(
      context: context,
      shadowColor: shadowColor,
      color: color,
      child: ThemedImage(
        path: image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderIcon({
    required BuildContext context,
    required Color shadowColor,
    required Color color,
  }) {
    return _generateCircle(
      context: context,
      shadowColor: shadowColor,
      color: color,
      child: Icon(
        icon,
        color: validateColor(color: color),
        size: iconSize ?? (size * 0.7),
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
    VoidCallback? onTap,
    VoidCallback? onLongTap,
    VoidCallback? onSecondaryTap,
  }) {
    switch (avatar.type) {
      case AvatarType.emoji:
        return _generateCircle(
          context: context,
          shadowColor: shadowColor,
          color: Colors.white,
          child: Text(
            avatar.emoji ?? _cleanName(name),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: size * 0.6),
          ),
        );
      case AvatarType.icon:
        return _renderIcon(
          context: context,
          shadowColor: shadowColor,
          color: color,
        );

      case AvatarType.base64:
        return _renderImage(
          image: avatar.base64 ?? '',
          context: context,
          shadowColor: shadowColor,
          color: color,
        );

      case AvatarType.url:
        return _renderImage(
          image: avatar.url ?? '',
          context: context,
          shadowColor: shadowColor,
          color: color,
        );

      default:
        return _generateDefault(context: context, shadowColor: shadowColor, color: color);
    }
  }

  Widget _generateDefault({
    required BuildContext context,
    required Color shadowColor,
    required Color color,
  }) {
    return _generateCircle(
      context: context,
      shadowColor: shadowColor,
      color: color,
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
    required Color shadowColor,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongTap,
          onSecondaryTap: onSecondaryTap,
          child: Center(child: child),
        ),
      ),
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
