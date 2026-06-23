import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/pasien.dart';

class PasienFormPage extends StatefulWidget {
  final Pasien? pasien;

  const PasienFormPage({super.key, this.pasien});

  @override
  State<PasienFormPage> createState() => _PasienFormPageState();
}

class _PasienFormPageState extends State<PasienFormPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _db = DatabaseHelper.instance;

  late TextEditingController _namaController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _noTeleponController;
  String _jenisKelamin = 'Laki-laki';

  bool get _isEdit => widget.pasien != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pasien?.nama ?? '');
    _tanggalLahirController = TextEditingController(text: widget.pasien?.tanggalLahir ?? '');
    _alamatController = TextEditingController(text: widget.pasien?.alamat ?? '');
    _noTeleponController = TextEditingController(text: widget.pasien?.noTelepon ?? '');
    if (widget.pasien != null) {
      _jenisKelamin = widget.pasien!.jenisKelamin;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final tanggalRegistrasi =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (_isEdit) {
      // Update
      final updatedPasien = widget.pasien!.copyWith(
        nama: _namaController.text.trim(),
        tanggalLahir: _tanggalLahirController.text.trim(),
        jenisKelamin: _jenisKelamin,
        alamat: _alamatController.text.trim(),
        noTelepon: _noTeleponController.text.trim(),
      );
      _db.updatePasien(updatedPasien);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pasien berhasil diupdate')),
      );
    } else {
      // Insert baru
      final noRM = _db.generateNoRekamMedis();
      final newPasien = Pasien(
        nama: _namaController.text.trim(),
        tanggalLahir: _tanggalLahirController.text.trim(),
        jenisKelamin: _jenisKelamin,
        alamat: _alamatController.text.trim(),
        noTelepon: _noTeleponController.text.trim(),
        noRekamMedis: noRM,
        tanggalRegistrasi: tanggalRegistrasi,
      );
      _db.insertPasien(newPasien);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pasien berhasil didaftarkan dengan No. RM: $noRM')),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Pasien' : 'Registrasi Pasien Baru'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info No. RM jika edit
                  if (_isEdit)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.badge_outlined),
                            const SizedBox(width: 12),
                            Text(
                              'No. Rekam Medis: ${widget.pasien!.noRekamMedis}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_isEdit) const SizedBox(height: 16),

                  // Nama
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Lahir
                  TextFormField(
                    controller: _tanggalLahirController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      hintText: 'YYYY-MM-DD',
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Tanggal lahir tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Jenis Kelamin
                  DropdownButtonFormField<String>(
                    value: _jenisKelamin,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _jenisKelamin = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Alamat
                  TextFormField(
                    controller: _alamatController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // No. Telepon
                  TextFormField(
                    controller: _noTeleponController,
                    decoration: const InputDecoration(
                      labelText: 'No. Telepon',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      hintText: '08xxxxxxxxxx',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'No. telepon tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Tombol Simpan & Batal
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _simpan,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(_isEdit ? 'Update' : 'Daftarkan Pasien'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
