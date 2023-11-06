import 'package:p_on/screen/main/tab/schedule/vo/vo_popular_stock.dart';

class Stock extends PopularStock {
  final String stockImagePath;

  Stock({
    required super.name,
    required super.yesterdayClosePrice,
    required super.currentPrice,
    required this.stockImagePath,
  });
}
