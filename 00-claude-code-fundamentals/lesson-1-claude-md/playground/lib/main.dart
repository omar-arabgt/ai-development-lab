import 'logger.dart';

// بتحسب ضريبة الجمرك على سعر السيارة
double gt_calculate_tax(double price) {
  return price * 0.15;
}

// بتحسب الخصم على سعر السيارة
double gt_calculate_discount(double price, double discountPercentage) {
  return price * (discountPercentage / 100);
}

// بتحسب سعر السيارة النهائي بعد إضافة الجمرك وطرح الخصم
double gt_calculate_final_price(double price, double discountPercentage) {
  return price + gt_calculate_tax(price) - gt_calculate_discount(price, discountPercentage);
}

// بتحول السعر من دولار أمريكي لدينار عراقي
double gt_convert_usd_to_iqd(double priceInUsd, {double exchangeRate = 1310}) {
  return priceInUsd * exchangeRate;
}

void main() {
  final price = 20000.0;
  gt_log('السعر: $price — الضريبة: ${gt_calculate_tax(price)}');
  gt_log('الخصم: ${gt_calculate_discount(price, 10)}');
  gt_log('السعر النهائي: ${gt_calculate_final_price(price, 10)}');
  gt_log('السعر بالدينار العراقي: ${gt_convert_usd_to_iqd(price)}');
}
