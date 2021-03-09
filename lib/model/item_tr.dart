import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ItemTr extends Equatable {
  final String? name;
  final int? hargaBeli;
  final int? hargaJual;
  final int? pcs;
  final GlobalKey<FormState>? formkey;
  final int? productId;
  final String? tempatBeli;
  final String? barcode;
  final int? id;
  final bool? open;
  final DateTime? expdate;
  final DateTime? ditambahkan;

  ItemTr(
      {this.name,
      this.hargaBeli,
      this.productId,
      this.hargaJual,
      this.pcs,
      this.formkey,
      this.barcode,
      this.tempatBeli,
      this.open,
      this.expdate,
      this.ditambahkan,
      this.id});
  ItemTr copywith(
      {String? name,
      int? hargaBeli,
      int? hargaJual,
      int? pcs,
      String? tempatBeli,
      int? productId,
      bool? open,
      GlobalKey<FormState>? formkey,
      String? barcode,
      DateTime? expdate,
      DateTime? ditambahkan,
      int? id}) {
    return ItemTr(
        barcode: barcode ?? this.barcode,
        open: open ?? this.open,
        name: name ?? this.name,
        formkey: formkey ?? this.formkey,
        productId: productId ?? this.productId,
        expdate: expdate ?? this.expdate,
        ditambahkan: ditambahkan ?? this.ditambahkan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        pcs: pcs ?? this.pcs,
        tempatBeli: tempatBeli ?? this.tempatBeli,
        id: id ?? this.id);
  }

  @override
  List<Object?> get props => [
        name,
        hargaBeli,
        hargaJual,
        pcs,
        tempatBeli,
        id,
        open,
        expdate,
        barcode,
        productId,
        ditambahkan,
        formkey
      ];

  @override
  String toString() {
    return 'open : $open';
    // return '''{id: $id,nama: $name,open:$open,$hargaBeli, $hargaJual,
    // $pcs, $tempatBeli, $id, $expdate, $barcode,$productId}''';
  }

  static ItemTr fromMap(Map data) {
    return ItemTr(
      barcode: data['BARCODE'].toString(),
      // open: data[''],
      name: data['NAMA'],
      // formkey: formkey ?? this.formkey,
      productId: data['ID_BRG'],
      expdate: DateTime.parse(data['EXP_DATE']),
      ditambahkan: DateTime.parse(data['ADD_DATE']),
      hargaBeli: data['HARGA_BELI'],
      hargaJual: data['HARGA_JUAL'],
      pcs: data['JUMLAH'],
      // tempatBeli: data['SUPPLIER'],
      // id: data['id']
    );
  }
}
