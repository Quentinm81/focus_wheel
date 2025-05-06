// Extensions utiles (exemple)
extension DateTimeExt on DateTime {
  String toShortDate() => '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
}
