part of helpers;

/// [getImage] is a helper function to get an image from a local file path, a network url or a base64 string.
Widget getImage(
  /// [path] is the path of the image. Can be a local file path, a network url or a base64 string.
  /// It's important to clarify that the base64 string must be in the format `data:image/png;base64,base64String`
  String path, {
  /// [height] is the height of the image. By default, it is `30`.
  double height = 30,

  /// [width] is the width of the image. By default, it is `100`.
  double width = 100,

  /// [fit] is the fit of the image. By default, it is `BoxFit.contain`.
  BoxFit fit = BoxFit.contain,

  /// [filterQuality] is the filter quality of the image. By default, it is `FilterQuality.medium`.
  /// You can change it to `FilterQuality.high` to get a better quality.
  FilterQuality filterQuality = FilterQuality.medium,

  /// [customProvider] is a custom image provider. By default, it is `null`.
  /// If you want to use a custom image provider, you can pass it here.
  /// It's important to note that if you pass a custom provider, the [path] will be ignored.
  ImageProvider? customProvider,

  /// [key] is the key of the image. By default, it is `null`.
  Key? key,
}) {
  ImageProvider provider;

  if (path.startsWith('http')) {
    provider = NetworkImage(path);
  } else if (path.startsWith('data:')) {
    provider = MemoryImage(base64Decode(path.split(',').last));
  } else {
    provider = AssetImage(path);
  }

  return Image(
    image: provider,
    height: height,
    width: width,
    fit: fit,
    filterQuality: filterQuality,
  );
}

class ThemedImage extends StatelessWidget {
  final String? path;
  final double height;
  final double width;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final ImageProvider? customProvider;

  const ThemedImage({
    super.key,

    /// [path] is the path of the image. Can be a local file path, a network url or a base64 string.
    /// It's important to clarify that the base64 string must be in the format `data:image/png;base64,base64String`
    this.path,

    /// [height] is the height of the image. By default, it is `30`.
    this.height = 30,

    /// [width] is the width of the image. By default, it is `100`.
    this.width = 100,

    /// [fit] is the fit of the image. By default, it is `BoxFit.contain`.
    this.fit = BoxFit.contain,

    /// [filterQuality] is the filter quality of the image. By default, it is `FilterQuality.medium`.
    /// You can change it to `FilterQuality.high` to get a better quality.
    this.filterQuality = FilterQuality.medium,

    /// [customProvider] is a custom image provider. By default, it is `null`.
    /// If you want to use a custom image provider, you can pass it here.
    /// It's important to note that if you pass a custom provider, the [path] will be ignored.
    this.customProvider,
  })  : assert(path != null || customProvider != null, 'You must provide a path or a custom provider'),
        assert(path == null || customProvider == null, 'You must provide a path or a custom provider, not both');

  ImageProvider get provider {
    if (customProvider != null) return customProvider!;

    if (path!.startsWith('http')) {
      return NetworkImage(path!);
    }
    if (path!.startsWith('data:')) {
      return MemoryImage(base64Decode(path!.split(',').last));
    }
    return AssetImage(path!);
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: provider,
      height: height,
      width: width,
      fit: fit,
      filterQuality: filterQuality,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: LinearProgressIndicator(
            color: Theme.of(context).dividerColor,
            backgroundColor: Colors.transparent,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
