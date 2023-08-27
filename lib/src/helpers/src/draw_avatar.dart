part of helpers;

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
/// The [shadowColor] is the color of the [BoxShadow], by default it is [Theme.of(context).dividerColor].
/// The [reverse] is the boolean to reverse shadow of the [BoxDecoration], by default it is false.
/// [context] is the context of the widget.

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
  assert(elevation <= 5, 'The elevation must be less than or equal to 5');
  assert(elevation >= 0, 'The elevation must be greater than or equal to 0');
  assert(radius >= 0, 'The radius must be greater than or equal to 0');

  Color containerColor = color ?? Theme.of(context).primaryColor;
  Widget content = const SizedBox();
  double contentSize = size * 0.4;

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
        containerColor = color ?? Colors.white;
        if ((dynamicAvatar.base64 ?? '').isEmpty) {
          content = Image.network(
            'https://cdn.layrz.com/resources/layo/layo.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            loadingBuilder: loadingProgressIndicator,
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
        containerColor = color ?? Colors.white;
        content = Image.network(
          dynamicAvatar.url ?? 'https://cdn.layrz.com/resources/layo/layo.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          loadingBuilder: loadingProgressIndicator,
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
    containerColor = Colors.white;
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
        loadingBuilder: loadingProgressIndicator,
      );
    } else if (avatar.isEmpty) {
      content = Image.network(
        'https://cdn.layrz.com/resources/layo/layo.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        loadingBuilder: loadingProgressIndicator,
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
      border: elevation == 0
          ? Border.all(
              color: shadowColor ?? Theme.of(context).dividerColor,
              width: 1,
            )
          : null,
      boxShadow: elevation > 0
          ? [
              BoxShadow(
                color: shadowColor ?? Theme.of(context).dividerColor,
                blurRadius: 2 * elevation.toDouble(),
                offset: Offset(0, elevation.toDouble() * (reverse ? -1 : 1)), // changes position of shadow
              ),
            ]
          : null,
    ),
    child: content,
  );
}
