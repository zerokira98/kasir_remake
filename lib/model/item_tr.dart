import 'package:equatable/equatable.dart';

class ItemTr extends Equatable {
  final String name;
  final int hargaBeli;
  final int hargaJual;
  final int pcs;
  final int productId;
  final String tempatBeli;
  final int barcode;
  final int id;
  final bool open;
  final DateTime expdate;

  ItemTr(
      {this.name,
      this.hargaBeli,
      this.productId,
      this.hargaJual,
      this.pcs,
      int barcode,
      String tempatBeli,
      this.open,
      this.expdate,
      int id})
      : this.id = id,
        this.barcode = barcode,
        this.tempatBeli = tempatBeli ?? '';
  ItemTr copywith(
      {String name,
      int hargaBeli,
      int hargaJual,
      int pcs,
      String tempatBeli,
      int productId,
      bool open,
      int barcode,
      DateTime expdate,
      int id}) {
    return ItemTr(
        barcode: barcode ?? this.barcode,
        open: open ?? this.open,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        expdate: expdate ?? this.expdate,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        pcs: pcs ?? this.pcs,
        tempatBeli: tempatBeli ?? this.tempatBeli,
        id: id ?? this.id);
  }

  @override
  List<Object> get props => [
        name,
        hargaBeli,
        hargaJual,
        pcs,
        tempatBeli,
        id,
        open,
        expdate,
        barcode,
        productId
      ];

  @override
  String toString() {
    return '''{id: $id,nama: $name,open:$open,$hargaBeli, $hargaJual, 
    $pcs, $tempatBeli, $id, $expdate, $barcode,$productId}''';
  }
}
