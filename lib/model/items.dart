import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String name;
  final int hargaBeli;
  final int hargaJual;
  final int pcs;
  final String tempatBeli;
  final int id;
  final bool open;

  Item(
      {this.name,
      this.hargaBeli,
      this.hargaJual,
      this.pcs,
      this.tempatBeli,
      this.open,
      int id})
      : this.id = id;
  Item copywith(
      {String name,
      int hargaBeli,
      int hargaJual,
      int pcs,
      String tempatBeli,
      bool open,
      int id}) {
    return Item(
        open: open ?? this.open,
        name: name ?? this.name,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        pcs: pcs ?? this.pcs,
        tempatBeli: tempatBeli ?? this.tempatBeli,
        id: id ?? this.id);
  }

  @override
  List<Object> get props => [name, hargaBeli, hargaJual, pcs, tempatBeli, id];

  @override
  String toString() {
    // TODO: implement toString
    return '{id: $id,nama: $name}';
  }
}
