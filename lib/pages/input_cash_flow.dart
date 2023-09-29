import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/db_helper.dart';
import 'home.dart';

class InputCashFlowPage extends StatefulWidget {
  const InputCashFlowPage({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<InputCashFlowPage> createState() => _InputCashFlowPageState();
}

final DateFormat formatter = DateFormat('dd/MM/yyyy');
DateTime selectedDate = DateTime.now();

class _InputCashFlowPageState extends State<InputCashFlowPage> {
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submitData() async {
    CashFlow cashFlow = CashFlow(
        amount: int.parse(_controllerAmount.text),
        description: _controllerDescription.text,
        date: selectedDate.toString(),
        type: widget.type == 'pemasukan' ? 0 : 1);
    await DataHelper().insertCashFlow(cashFlow);
  }

  void resetForm() {
    setState(() {
      _controllerAmount.clear();
      _controllerDescription.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              (widget.type == 'pemasukan')
                  ? 'Tambah Pemasukan'
                  : 'Tambah Pengeluaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (widget.type == 'pemasukan')
                    ? Colors.green
                    : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.7,
                  child: TextField(
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: formatter.format(selectedDate),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.1,
                  child: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Nominal',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: width * 0.9,
              child: TextField(
                controller: _controllerAmount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Text('Rp '),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  hintText: '0',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keterangan',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: width * 0.9,
              child: TextField(
                controller: _controllerDescription,
                decoration: const InputDecoration(
                  hintText: 'Keterangan',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetForm();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () {
                submitData();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>  HomePage()),
                    (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: const Text('<< Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
