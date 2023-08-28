part of helpers;

/// [getImage] is a helper function to get an image from a local file path, a network url or a base64 string.
///
/// This function is's a wrapper of the [ThemedImage] widget. So, if you want to control more properties of the image,
/// you can use the [ThemedImage] widget instead.
///
/// [path] is the path of the image. Can be a local file path, a network url or a base64 string.
/// It's important to clarify that the base64 string must be in the format `data:image/png;base64,base64String`
/// [height] is the height of the image. By default, it is `30`.
/// [width] is the width of the image. By default, it is `100`.
/// [fit] is the fit of the image. By default, it is `BoxFit.contain`.
/// [filterQuality] is the filter quality of the image. By default, it is `FilterQuality.medium`.
/// You can change it to `FilterQuality.high` to get a better quality.
/// [customProvider] is a custom image provider. By default, it is `null`.
/// If you want to use a custom image provider, you can pass it here.
/// It's important to note that if you pass a custom provider, the [path] will be ignored.
/// [key] is the key of the image. By default, it is `null`.
Widget getImage(
  String path, {
  double height = 30,
  double width = 100,
  BoxFit fit = BoxFit.contain,
  FilterQuality filterQuality = FilterQuality.medium,
  ImageProvider? customProvider,
  Key? key,
}) {
  return ThemedImage(
    key: key,
    path: path,
    height: height,
    width: width,
    fit: fit,
    filterQuality: filterQuality,
    customProvider: customProvider,
  );
}

class ThemedImage extends StatelessWidget {
  /// [path] is the path of the image. Can be a local file path, a network url or a base64 string.
  /// It's important to clarify that the base64 string must be in the format `data:image/png;base64,base64String`
  final String? path;

  /// [height] is the height of the image. By default, it is `30`.
  final double height;

  /// [width] is the width of the image. By default, it is `100`.
  final double width;

  /// [fit] is the fit of the image. By default, it is `BoxFit.contain`.
  final BoxFit fit;

  /// [filterQuality] is the filter quality of the image. By default, it is `FilterQuality.medium`.
  /// You can change it to `FilterQuality.high` to get a better quality.
  final FilterQuality filterQuality;

  /// [customProvider] is a custom image provider. By default, it is `null`.
  /// If you want to use a custom image provider, you can pass it here.
  /// It's important to note that if you pass a custom provider, the [path] will be ignored.
  final ImageProvider? customProvider;

  const ThemedImage({
    super.key,
    this.path,
    this.height = 30,
    this.width = 100,
    this.fit = BoxFit.contain,
    this.filterQuality = FilterQuality.medium,
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
