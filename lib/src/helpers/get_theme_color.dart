part of helpers;

MaterialColor getThemeColor({required String theme, Color color = kPrimaryColor}) {
  switch (theme) {
    case 'CUSTOM':
      return generateSwatch(color: color);
    case 'PINK':
      return Colors.pink;
    case 'RED':
      return Colors.red;
    case 'DEEPORANGE':
      return Colors.deepOrange;
    case 'ORANGE':
      return Colors.orange;
    case 'AMBER':
      return Colors.amber;
    case 'YELLOW':
      return Colors.yellow;
    case 'LIME':
      return Colors.lime;
    case 'LIGHTGREEN':
      return Colors.lightGreen;
    case 'GREEN':
      return Colors.green;
    case 'TEAL':
      return Colors.teal;
    case 'CYAN':
      return Colors.cyan;
    case 'LIGHTBLUE':
      return Colors.lightBlue;
    case 'BLUE':
      return Colors.blue;
    case 'INDIGO':
      return Colors.indigo;
    case 'DEEPBLUE':
      return Colors.deepPurple;
    case 'PURPLE':
      return Colors.purple;
    case 'BLUEGREY':
      return Colors.blueGrey;
    case 'GREY':
      return Colors.grey;
    case 'BROWN':
      return Colors.brown;
    default:
      return generateSwatch(color: kPrimaryColor);
  }
}
