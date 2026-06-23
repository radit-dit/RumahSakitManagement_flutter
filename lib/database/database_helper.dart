import '../models/pasien.dart';

class DatabaseHelper {
  // Singleton
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;

  final List<Map<String, dynamic>> _data = [];
  int _nextId = 1;
  int _nextRekamMedis = 1;

  /// Generate nomor rekam medis otomatis: RM-000001, RM-000002, ...
  String generateNoRekamMedis() {
    final nomor = _nextRekamMedis.toString().padLeft(6, '0');
    _nextRekamMedis++;
    return 'RM-$nomor';
  }

  /// Insert pasien baru, return ID
  int insertPasien(Pasien pasien) {
    final id = _nextId++;
    final map = pasien.toMap();
    map['id'] = id;
    _data.add(map);
    return id;
  }

  /// Ambil semua data pasien
  List<Pasien> getPasienList() {
    return _data.map((map) => Pasien.fromMap(map)).toList();
  }

  /// Ambil pasien berdasarkan ID
  Pasien? getPasienById(int id) {
    try {
      final map = _data.firstWhere((m) => m['id'] == id);
      return Pasien.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  /// Update data pasien
  bool updatePasien(Pasien pasien) {
    final index = _data.indexWhere((m) => m['id'] == pasien.id);
    if (index == -1) return false;
    _data[index] = pasien.toMap();
    return true;
  }

  /// Hapus pasien berdasarkan ID
  bool deletePasien(int id) {
    final index = _data.indexWhere((m) => m['id'] == id);
    if (index == -1) return false;
    _data.removeAt(index);
    return true;
  }

  /// Cari pasien berdasarkan nama atau no rekam medis
  List<Pasien> searchPasien(String query) {
    final lowerQuery = query.toLowerCase();
    return _data
        .where((m) =>
            (m['nama'] as String).toLowerCase().contains(lowerQuery) ||
            (m['noRekamMedis'] as String).toLowerCase().contains(lowerQuery))
        .map((map) => Pasien.fromMap(map))
        .toList();
  }
}
