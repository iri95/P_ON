import 'package:p_on/screen/main/tab/schedule/vo/vo_simple_stock.dart';

import 'stock_percentage_data_provider.dart';

class PopularStock extends SimpleStock with StockPercentageDataProvider {
  @override
  final int yesterdayClosePrice;
  @override
  final int currentPrice;

  PopularStock({
    required String name,
    required this.yesterdayClosePrice,
    required this.currentPrice,
  }) : super(name);
}
