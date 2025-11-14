part of '../helpers.dart';

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

  /// [alignment] is the alignment of the image. By default, it is `Alignment.center`.
  final Alignment alignment;

  ThemedImage({
    super.key,
    this.path,
    this.height = 30,
    this.width = 100,
    this.fit = .contain,
    this.filterQuality = .medium,
    this.customProvider,
    this.alignment = .center,
  }) : assert(path != null || customProvider != null, 'You must provide a path or a custom provider'),
       assert(path == null || customProvider == null, 'You must provide a path or a custom provider, not both');

  bool get isSvg {
    if (customProvider != null) return false;

    if (isNetwork) {
      return path!.endsWith('.svg');
    }

    if (isBase64) {
      return path!.startsWith('data:image/svg+xml');
    }

    return path!.endsWith('.svg');
  }

  bool get isNetwork {
    if (customProvider != null) return false;
    return path!.startsWith('http');
  }

  bool get isBase64 {
    if (customProvider != null) return false;
    return path!.startsWith('data:');
  }

  ImageProvider get provider {
    if (customProvider != null) return customProvider!;

    if (isNetwork) {
      return NetworkImage(path!);
    }
    if (isBase64) {
      return MemoryImage(base64Decode(path!.split(',').last));
    }
    return AssetImage(path!);
  }

  final Map<int, Uint8List> _svgCache = {};

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      if (isNetwork) {
        return SvgPicture.network(
          path!,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      }

      if (isBase64) {
        if (!_svgCache.containsKey(path.hashCode)) {
          _svgCache[path.hashCode] = base64Decode(path!.split(',').last);
        }

        return SvgPicture.memory(
          _svgCache[path.hashCode]!,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      }

      return SvgPicture.asset(
        path!,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
      );
    }
    return Image(
      image: provider,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
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
