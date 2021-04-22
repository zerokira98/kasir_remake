part of 'stockview.dart';

class FilterBox extends StatelessWidget {
  final dateFrom = TextEditingController();
  final dateTo = TextEditingController();

  ///*Edit this var plz-----------------
  // final dateFromFull, dateToFull;
  final namaBarang = TextEditingController();
  final int dropdownValue = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockviewBloc, StockviewState>(
      builder: (context, state) {
        if (state is StockviewLoaded) {
          namaBarang.text = state.filter.nama ?? '';
          return Container(
            // color: Colors.blue,
            // margin: EdgeInsets.all(18.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 8.0,
                //     color: Colors.grey,
                //     offset: Offset(8.0, 8.0),
                //   ),
                //   // BoxShadow(
                //   //   blurRadius: 8.0,
                //   //   color: Colors.white,
                //   //   offset: Offset(-8.0, -8.0),
                //   // )
                // ],
                border: Border.all(color: Colors.grey[50]!),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.0))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: namaBarang,
                        decoration: InputDecoration(
                          labelText: 'Nama barang',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          labelText: 'Tempat beli',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Tanggal : '),
                    Expanded(
                      child:
                          // InputDatePickerFormField(
                          //     firstDate: DateTime.now(), lastDate: DateTime.now()),
                          InkWell(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));

                          dateFrom.text =
                              selectedDate.toString().substring(0, 10);
                          // dateFromFull = selectedDate.toString();
                        },
                        child: TextField(
                          enabled: false,
                          controller: dateFrom,
                          decoration: InputDecoration(labelText: 'From'),
                        ),
                      ),
                    ),
                    Text(' - '),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          dateTo.text =
                              selectedDate.toString().substring(0, 10);
                          // dateToFull = selectedDate.toString();
                        },
                        child: TextField(
                          controller: dateTo,
                          enabled: false,
                          decoration: InputDecoration(labelText: 'To'),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('Sort by:'),
                    DropdownButton(
                        value: dropdownValue,
                        items: [
                          DropdownMenuItem(
                            child: Text('Nama A->Z'),
                            value: 0,
                          ),
                          DropdownMenuItem(
                            child: Text('Nama Z->A'),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Ascending'),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text('Tanggal Descending'),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli A->Z'),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text('Tempat Beli Z->A'),
                            value: 5,
                          ),
                        ],
                        onChanged: (dynamic v) {
                          // dropdownValue = v;
                        }),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print(dateTo.text);
                          // print(namaBarang.text + dateFromFull + dateToFull);
                          BlocProvider.of<StockviewBloc>(context)
                              .add(FilterChange(
                            name: namaBarang.text,
                            page: 0,
                            dateStart: dateFrom.text,
                            dateEnd: dateTo.text,
                          ));

                          Navigator.pop(context);
                        },
                        child: Text('Go'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
