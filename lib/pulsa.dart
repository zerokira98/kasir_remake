import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

enum Provider { Telkomsel, Indosat, Xl, Axis, Three, Smartfren, Unidentified }

final numFormat = NumberFormat("#,##0", "en_US");

class TransaksiPulsa extends StatefulWidget {
  @override
  _TransaksiPulsaState createState() => _TransaksiPulsaState();
}

class _TransaksiPulsaState extends State<TransaksiPulsa> {
  var telkomsel = [
    "0812",
    "0813",
    "0821",
    "0822",
    "0852",
    "0853",
    "0823",
    "0851"
  ];
  var indosat = ["0814", "0815", "0816", "0855", "0856", "0857", "0858"];
  var three = ["0895", "0896", "0897", "0898", "0899"];
  var smartfren = [
    "0881",
    "0882",
    "0883",
    "0884",
    "0885",
    "0886",
    "0887",
    "0888",
    "0889"
  ];
  var xl = ["0817", "0818", "0819", "0859", "0877", "0878"];
  var axis = ["0838", "0831", "0832", "0833"];
  Provider provider = Provider.Unidentified;
  var nomorController = TextEditingController();
  var kodeController = TextEditingController();
  String kode = '',
      nominal = '',
      nomorHP = '',
      pin = '1234',
      smsCenter = '081354077500';
  @override
  void initState() {
    nomorController.addListener(() {
      nomorListener();
    });
    super.initState();
  }

  bool get isValid => provider != Provider.Unidentified && nomorHP.length > 10;

  int nominalValue;
  var nominalData = [
    5000,
    10000,
    20000,
    0,
    50000,
    100000,
  ];
  void nomorListener() {
    nomorHP = nomorController.text.trim();
    if (nomorController.text.length >= 4) {
      setState(() {
        provider = checkNumberProvider(nomorHP.substring(0, 4));
        kode = getCode(provider);
      });
    } else {
      setState(() {
        provider = Provider.Unidentified;
      });
    }
    if (provider == Provider.Three) {
      nominalData[3] = 30000;
    } else {
      nominalData[3] = 25000;
    }
    kodeController.text =
        kode + nominal + '.' + nomorController.text + '.' + pin;
  }

  String getCode(Provider pvd) {
    switch (pvd) {
      case Provider.Axis:
        return 'X';
        break;
      case Provider.Indosat:
        return 'MM';
        break;
      case Provider.Smartfren:
        return 'I';
        break;
      case Provider.Telkomsel:
        return 'S';
        break;
      case Provider.Three:
        return 'T';
        break;
      case Provider.Xl:
        return 'X';
        break;
      default:
        return '';
    }
  }

  Provider checkNumberProvider(String nomor) {
    if (telkomsel.contains(nomor))
      return Provider.Telkomsel;
    else if (axis.contains(nomor))
      return Provider.Axis;
    else if (xl.contains(nomor))
      return Provider.Xl;
    else if (smartfren.contains(nomor))
      return Provider.Smartfren;
    else if (indosat.contains(nomor))
      return Provider.Indosat;
    else if (three.contains(nomor))
      return Provider.Three;
    else
      return Provider.Unidentified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isi Pulsa')),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nomorController,
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(),
                  // hintText: 'Masukkan Nomor',
                ),
                keyboardType: TextInputType.phone,
              ),
              Row(
                children: [
                  Text('Nominal : '),
                  DropdownButton(
                      hint: Text('Pilih'),
                      value: nominalValue,
                      items: nominalData.map((e) {
                        return DropdownMenuItem(
                          child: Text('${numFormat.format(e)}'),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          nominalValue = val;
                          nominal = (val ~/ 1000).toString();

                          kodeController.text = kode +
                              nominal +
                              '.' +
                              nomorController.text +
                              '.' +
                              pin;
                        });
                      }),
                  Text('provider : ' + (provider.toString()).split('.')[1]),
                ],
              ),
              Text(
                '*tidak semua nomor bisa menggunakan nominal tertentu. cek kembali daftar kodenya.',
                textScaleFactor: 0.65,
                textAlign: TextAlign.start,
              ),
              Stack(
                children: [
                  TextFormField(
                    enabled: false,
                    controller: kodeController,
                    decoration: InputDecoration(
                      hintText: 'Kode',
                    ),
                  ),
                  Positioned(
                    right: 2.0,
                    child: Builder(
                      builder: (context) => IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: !isValid
                              ? null
                              : () {
                                  Clipboard.setData(
                                      ClipboardData(text: kodeController.text));
                                  // ClipboardData(text: kodeController.text);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Code Copied'),
                                  ));
                                  print('pressed');
                                }),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('SMS Centre:'),
                  DropdownButton(
                      items: [
                        DropdownMenuItem(
                          child: Text('081354077500'),
                          value: '081354077500',
                        ),
                        DropdownMenuItem(
                          child: Text('087858709555'),
                          value: '087858709555',
                        ),
                        DropdownMenuItem(
                          child: Text('081555671777'),
                          value: '081555671777',
                        ),
                      ],
                      value: smsCenter,
                      onChanged: (val) {
                        setState(() {
                          smsCenter = val;
                        });
                      }),
                  Text(checkNumberProvider(smsCenter.substring(0, 4))
                      .toString()
                      .split('.')[1]),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        // var uri = 'sms:$smsCenter?body=${kodeController.text}';
                        var uri =
                            'whatsapp://send?phone=$smsCenter?text=${kodeController.text}';
                        if (await canLaunch(uri)) {
                          print(uri);
                          launch(uri);
                        }
                      },
                      child: Text(
                        'Open SMS App',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
