import 'logger.dart';

// بتحسب ضريبة الجمرك على سعر السيارة
double gt_calculate_tax(double price) {
  return price * 0.15;
}

// بتحسب الخصم على سعر السيارة
double gt_calculate_discount(double price, double discountPercentage) {
  return price * (discountPercentage / 100);
}

void main() {
  final price = 20000.0;
  gt_log('السعر: $price — الضريبة: ${gt_calculate_tax(price)}');
  gt_log('الخصم: ${gt_calculate_discount(price, 10)}');
}
