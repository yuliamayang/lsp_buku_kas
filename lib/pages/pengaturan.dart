import 'package:flutter/material.dart';

import '../services/db_helper.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<bool> updatePassword() async {
    return await DataHelper().updatePassword(
        _currentPasswordController.text, _newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ganti Password',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text('Password Saat ini'),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const Text('Password Baru'),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                (_currentPasswordController.text == "" ||
                        _newPasswordController.text == "")
                    ? showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Field tidak boleh kosong'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      )
                    : updatePassword().then(
                        (value) {
                          if (value) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Success'),
                                  content:
                                      const Text('Password berhasil diubah'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Password gagal diubah, cek password saat ini'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
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
            SizedBox(height: height / 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                    image: const DecorationImage(
                      image: AssetImage('assets/p.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'About this App',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Aplikasi ini dibuat oleh :'),
                    Text(
                      'Nama : Yulia Mayangsari',
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('NIM : 2141764055'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
