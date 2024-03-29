part of 'stockview.dart';

class StockviewCard extends StatefulWidget {
  @override
  Key get key => _key;
  final Key _key;

  final ItemTr data;
  StockviewCard(this.data, this._key);

  @override
  _StockviewCardState createState() => _StockviewCardState();
}

class _StockviewCardState extends State<StockviewCard> {
  double horizontal = 0.0;
  @override
  Widget build(BuildContext context) {
    var hargaBeli = numFormat.format(widget.data.hargaBeli);
    var hargaJual = numFormat.format(widget.data.hargaJual);
    var totalBeli = numFormat.format(widget.data.pcs! * widget.data.hargaBeli!);
    print('tempat:' + (widget.data.tempatBeli ?? ''));
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print(details.delta);
        setState(() {
          horizontal += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        var width = MediaQuery.of(context).size.width;
        if (horizontal >= width * 0.5) {
          setState(() {
            horizontal = width;
          });
        } else if (horizontal <= width * -0.5) {
          setState(() {
            horizontal = -width;
          });
        } else {
          setState(() {
            horizontal = 0.0;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            child: ListTile(
              isThreeLine: true,
              // shape: RoundedRectangleBorder( ),
              // tileColor: Colors.white,
              title: Text(''),
              subtitle: Row(
                children: [
                  Text('' + '\n' + '\n'),
                  Expanded(
                    child: Container(),
                  ),
                  Text(' \n' + '\n')
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: Container(
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Are you sure want to delete?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          BlocProvider.of<StockviewBloc>(context)
                              .add(DeleteEntry(widget.data));
                        },
                        child:
                            Text('Yes', style: TextStyle(color: Colors.white))),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          horizontal = 0.0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      )),
                ],
              ),
            ),
          )),
          AnimatedContainer(
            duration: Duration(milliseconds: 450),
            transform: Matrix4.identity()..translate(horizontal),
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(),
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.black26),
              ],
              color: Colors.white,
            ),
            child: ListTile(
              isThreeLine: true,
              // shape: RoundedRectangleBorder( ),
              // tileColor: Colors.white,
              title: Text(widget.data.namaBarang.toString()),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text('Tempat beli: ${widget.data.tempatBeli}' +
                        '\nTanggal beli : ${widget.data.ditambahkan.toString().substring(0, 10)}' +
                        '\nJumlah item : ${widget.data.pcs}pcs'),
                  ),
                  // Expanded(
                  //   child: Container(),
                  // ),
                  Flexible(
                    // fit: FlexFit.tight,
                    child: Text(
                      'Harga jual : $hargaJual \nHarga beli : $hargaBeli' +
                          '\nTotal beli : $totalBeli',
                      // maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
