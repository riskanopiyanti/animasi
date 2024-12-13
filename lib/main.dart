import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Daftar transaksi
  List<Map<String, dynamic>> transactions = [
    {"title": "Belanja Mingguan", "amount": 100000, "type": "Pengeluaran"},
    {"title": "Gaji Bulanan", "amount": 2000000, "type": "Pemasukan"},
  ];

  // Menambahkan transaksi baru
  void addTransaction(Map<String, dynamic> transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  // Mengedit transaksi
  void editTransaction(int index, Map<String, dynamic> transaction) {
    setState(() {
      transactions[index] = transaction;
    });
  }

  // Menghapus transaksi
  void deleteTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  // Dialog untuk Tambah/Edit Transaksi
  void showTransactionDialog({int? index}) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(
        text: index != null ? transactions[index]['title'] : "");
    final amountController = TextEditingController(
        text: index != null ? transactions[index]['amount'].toString() : "");
    String transactionType =
        index != null ? transactions[index]['type'] : "Pengeluaran";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(index == null ? "Tambah Transaksi" : "Edit Transaksi"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Judul"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Judul tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Nominal"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nominal tidak boleh kosong";
                  }
                  if (double.tryParse(value) == null) {
                    return "Masukkan angka yang valid";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: transactionType,
                items: ["Pengeluaran", "Pemasukan"]
                    .map((type) => DropdownMenuItem(
                          child: Text(type),
                          value: type,
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) transactionType = value;
                },
                decoration: InputDecoration(labelText: "Jenis Transaksi"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final transaction = {
                  "title": titleController.text,
                  "amount": double.parse(amountController.text),
                  "type": transactionType,
                };
                if (index == null) {
                  addTransaction(transaction);
                } else {
                  editTransaction(index, transaction);
                }
                Navigator.of(ctx).pop();
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 106, 162, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Bungkus dengan SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak Ringkasan Keuangan
              Text(
                "Ringkasan Keuangan Riska",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // GridView di dalam SingleChildScrollView
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true, // Menyesuaikan dengan ukuran konten
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics:
                    NeverScrollableScrollPhysics(), // Nonaktifkan scroll untuk GridView
                children: [
                  SummaryCard(
                    title: "Rencana Bulanan",
                    value: "Rp 2.000.000",
                    color: const Color.fromARGB(255, 106, 162, 253),
                  ),
                  SummaryCard(
                    title: "Tabungan",
                    value: "Rp 10.000.000",
                    color: const Color.fromARGB(255, 106, 162, 253),
                  ),
                  SummaryCard(
                    title: "Pengeluaran",
                    value: "Rp 1.500.000",
                    color: const Color.fromARGB(255, 106, 162, 253),
                  ),
                  SummaryCard(
                    title: "Tagihan",
                    value: "Rp 500.000",
                    color: const Color.fromARGB(255, 106, 162, 253),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Riwayat Transaksi
              Text(
                "Riwayat Transaksi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // ListView.builder
              SizedBox(
                height: 300, // Batasi tinggi ListView
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: transaction['type'] == "Pengeluaran"
                              ? Colors.red
                              : Colors.green,
                          child: Icon(
                            transaction['type'] == "Pengeluaran"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(transaction['title']),
                        subtitle: Text(transaction['type']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Rp ${transaction['amount']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transaction['type'] == "Pengeluaran"
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTransaction(index),
                            ),
                          ],
                        ),
                        onTap: () => showTransactionDialog(index: index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTransactionDialog(),
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 106, 162, 253),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  SummaryCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
