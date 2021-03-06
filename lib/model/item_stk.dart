import 'package:equatable/equatable.dart';

class ItemStk extends Equatable {
  final String name;
  final int hargaBeli;
  final int hargaJual;
  final int pcs;
  final String tempatBeli;
  final int id;
  ItemStk(
      {this.name,
      this.hargaBeli,
      this.hargaJual,
      this.pcs,
      this.tempatBeli,
      this.id});

  @override
  List<Object> get props => [];
}
