import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Unit test pertama: Tambah transaksi baru
  testWidgets('Tambah transaksi baru', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    final transactionTitleFinder = find.text('Belanja Mingguan');
    expect(transactionTitleFinder, findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Transaksi Baru'), findsOneWidget);
  });

  // Unit test kedua: Test tampilan transaksi
  testWidgets('Tampilan transaksi', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    final transactionTitleFinder = find.text('Transaksi Baru');
    expect(transactionTitleFinder, findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Transaksi Baru'), findsOneWidget);
  });

  // Unit test ketiga: Tombol simpan
  testWidgets('Tombol simpan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));

    final saveButtonFinder = find.byIcon(Icons.save);
    expect(saveButtonFinder, findsOneWidget);

    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 1));

    expect(find.text('Data berhasil disimpan'), findsOneWidget);
  });
}

// Contoh widget utama, ganti dengan widget Anda
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Pengelolaan Keuangan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Belanja Mingguan'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Simulasi aksi simpan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil disimpan')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
