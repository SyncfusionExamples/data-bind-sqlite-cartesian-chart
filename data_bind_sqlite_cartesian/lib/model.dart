class SalesData {
  static const tblSales = 'salestable';
  static const salesXValue = 'xValue';
  static const salesYValue = 'yValue';

  SalesData({this.xValue, this.yValue});

  num? xValue;
  num? yValue;

  SalesData.fromMap(Map<String, dynamic> map) {
    xValue = map[salesXValue];
    yValue = map[salesYValue];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{salesXValue: xValue, salesYValue: yValue};
    return map;
  }
}
