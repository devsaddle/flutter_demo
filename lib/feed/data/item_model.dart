import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

@JsonSerializable()
class ItemModel extends Object {
  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'date')
  int? date;

  @JsonKey(name: 'from')
  String? from;

  @JsonKey(name: 'text')
  String? text;

  get formatDate {
    var formatter = DateFormat('yyyy-MM-dd HH:MM');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date ?? 0));
  }

  ItemModel(
    this.image,
    this.date,
    this.from,
    this.text,
  );
}
