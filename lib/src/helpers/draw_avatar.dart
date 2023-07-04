part of helpers;

/// [drawAvatar] is a helper function to generate a [CircleAvatar] using the avatar and the name
/// (as failover) of the entity.
/// The priority order of each property is:
/// 1. [dynamicAvatar]
/// 2. [avatar]
/// 3. [icon]
/// 4. [name]
Widget drawAvatar({
  /// [dynamicAvatar] is the new avatar engine, can be nullable.
  /// Prevent submit [avatar] and [icon] if you are using this.
  /// Nothing will happend but is less code to you :)
  Avatar? dynamicAvatar,

  /// [avatar] is the avatar of the user. Can be nullable
  String? avatar,

  /// [icon] is the icon of the user. Can be nullable
  IconData? icon,

  /// [name] is the name of the user. Can be nullable
  String? name,

  /// [size] is the size of the avatar.
  /// By default, it is 30.
  /// You can control the radius using [radius] property
  /// By default, it is 30. (The same as the [size])
  double size = 30,
  double radius = 30,

  /// [color] is the color of the avatar. By default, it is [Theme.of(context).primaryColor].
  /// When [dynamicAvatar.type] is [AvatarType.emoji], [AvatarType.base64], [AvatarType.url] or
  /// [avatar] is not [null] the color will be override to [Colors.grey.shade900]
  Color? color,

  /// [context] is the context of the widget.
  required BuildContext context,
}) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;
  Color containerColor = color ?? (isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor);
  Widget content = const SizedBox();
  double contentSize = size * 0.4;

  if (dynamicAvatar != null) {
    switch (dynamicAvatar.type) {
      case AvatarType.emoji:
        containerColor = Colors.grey.shade900;
        content = Center(
          child: Text(
            dynamicAvatar.emoji ?? 'NA',
            style: TextStyle(
              fontSize: contentSize,
            ),
          ),
        );
        break;
      case AvatarType.icon:
        content = Icon(
          dynamicAvatar.icon ?? Icons.person,
          color: validateColor(color: containerColor),
          size: contentSize,
        );
        break;
      case AvatarType.base64:
        containerColor = Colors.transparent;
        if ((dynamicAvatar.base64 ?? '').isEmpty) {
          content = Image.network(
            'https://cdn.layrz.com/resources/layo/layo.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          );
        } else {
          content = Image.memory(
            base64Decode(dynamicAvatar.base64!.split(',').last),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          );
        }
        break;
      case AvatarType.url:
        containerColor = Colors.transparent;
        content = Image.network(
          dynamicAvatar.url ?? 'https://cdn.layrz.com/resources/layo/layo.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        );
        break;
      default:
        content = Center(
          child: Text(
            name != null
                ? name.length >= 2
                    ? name.substring(0, 2).toUpperCase()
                    : name
                : 'NA',
            style: TextStyle(
              color: validateColor(color: containerColor),
              fontSize: contentSize,
            ),
          ),
        );
        break;
    }
  } else if (avatar != null && avatar.isNotEmpty) {
    containerColor = Colors.transparent;
    if (avatar.startsWith('data:')) {
      content = Image.memory(
        base64Decode(avatar.split(',').last),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    } else if (avatar.startsWith('http')) {
      content = Image.network(
        avatar,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    } else if (avatar.isEmpty) {
      content = Image.network(
        'https://cdn.layrz.com/resources/layo/layo.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    } else {
      content = Image.asset(
        avatar,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    }
  } else if (icon != null) {
    content = Center(
      child: Icon(
        icon,
        color: validateColor(color: containerColor),
        size: contentSize,
      ),
    );
  } else {
    content = Center(
      child: Text(
        name != null
            ? name.length >= 2
                ? name.substring(0, 2).toUpperCase()
                : name
            : 'NA',
        style: TextStyle(
          color: validateColor(color: containerColor),
          fontSize: contentSize,
        ),
      ),
    );
  }

  return Container(
    width: size,
    height: size,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: containerColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 4,
          spreadRadius: 2,
        ),
      ],
    ),
    child: content,
  );
}
