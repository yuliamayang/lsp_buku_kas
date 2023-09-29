import 'package:flutter_buku_kas/pages/list_cashflow.dart';
import 'package:flutter_buku_kas/pages/login_page.dart';
import 'package:flutter_buku_kas/pages/pengaturan.dart';
import 'package:flutter_buku_kas/pages/input_cash_flow.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/pemasukan': (context) => const InputCashFlowPage(type: 'pemasukan'),
        '/pengeluaran': (context) => const InputCashFlowPage(
              type: 'pengeluaran',
            ),
        '/cashFlow': (context) => const CashFlowPage(),
        '/pengaturan': (context) => const PengaturanPage(),
      },
    );
  }
}
