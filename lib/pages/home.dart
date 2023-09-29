import 'package:flutter_buku_kas/models/cash_flow.dart';
import 'package:flutter_buku_kas/models/menu.dart';
import 'package:flutter_buku_kas/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/graph_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Menu> _listMenu = [
  Menu(
    name: 'Tambah Pemasukan',
    icon: 'assets/income.png',
    route: '/pemasukan',
  ),
  Menu(
    name: 'Tambah Pengeluaran',
    icon: 'assets/expense.png',
    route: '/pengeluaran',
  ),
  Menu(
    name: 'Detail Cashflow',
    icon: 'assets/detail.png',
    route: '/cashFlow',
  ),
  Menu(
    name: 'Pengaturan',
    icon: 'assets/setting.png',
    route: '/pengaturan',
  ),
];
final formatter = NumberFormat("#,##0.00", "en_US");

class _HomePageState extends State<HomePage> {
  int _pengeluaran = 0;
  int _pemasukan = 0;

  late DataHelper dataHelper;
  int count = 0;

  @override
  void initState() {
    dataHelper = DataHelper();
    initData();
    super.initState();
  }

  void initData() async {
    List<CashFlow> listCashFlow = await dataHelper.selectCashFlow();
    for (CashFlow cashFlow in listCashFlow) {
      if (cashFlow.type == 0) {
        _pemasukan += cashFlow.amount!;
      } else {
        _pengeluaran += cashFlow.amount!;
      }
    }
    dataHelper.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white, // Ganti warna latar belakang
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Rangkuman Bulan Ini',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Ubah ukuran font
                  color: Colors.black, // Ganti warna teks
                ),
              ),
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pemasukan',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13, color: Colors.green)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('Rp ${formatter.format(_pemasukan)}',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16, color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pengeluaran',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13, color: Colors.red)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('Rp ${formatter.format(_pengeluaran)}',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16, color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )),
            SizedBox(
              height: height / 30,
            ),
            SizedBox(
              height: height / 4,
              child: const GraphCard(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                height: height - 280,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20, // Ubah jarak antara menu
                  mainAxisSpacing: 20, // Ubah jarak antara menu
                  children: <Widget>[
                    for (Menu menu in _listMenu)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, menu.route!);
                        },
                        child: Card(
                          color: Colors.white, // Ganti warna kartu
                          elevation: 5, // Tambah bayangan kartu
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Agar kartu memiliki sudut bulat
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(menu.icon!, width: height / 6),
                              const SizedBox(
                                  height:
                                      10), // Tambah ruang antara gambar dan teks
                              Expanded(
                                child: Text(
                                  menu.name!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13, // Ubah ukuran font
                                    fontWeight: FontWeight
                                        .bold, // Tambah ketebalan teks
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
