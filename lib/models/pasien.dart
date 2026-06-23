class Pasien {
  final int? id;
  final String nama;
  final String tanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String noTelepon;
  final String noRekamMedis;
  final String tanggalRegistrasi;

  Pasien({
    this.id,
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.noTelepon,
    required this.noRekamMedis,
    required this.tanggalRegistrasi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
      'noTelepon': noTelepon,
      'noRekamMedis': noRekamMedis,
      'tanggalRegistrasi': tanggalRegistrasi,
    };
  }

  factory Pasien.fromMap(Map<String, dynamic> map) {
    return Pasien(
      id: map['id'] as int?,
      nama: map['nama'] as String,
      tanggalLahir: map['tanggalLahir'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      alamat: map['alamat'] as String,
      noTelepon: map['noTelepon'] as String,
      noRekamMedis: map['noRekamMedis'] as String,
      tanggalRegistrasi: map['tanggalRegistrasi'] as String,
    );
  }

  Pasien copyWith({
    int? id,
    String? nama,
    String? tanggalLahir,
    String? jenisKelamin,
    String? alamat,
    String? noTelepon,
    String? noRekamMedis,
    String? tanggalRegistrasi,
  }) {
    return Pasien(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      alamat: alamat ?? this.alamat,
      noTelepon: noTelepon ?? this.noTelepon,
      noRekamMedis: noRekamMedis ?? this.noRekamMedis,
      tanggalRegistrasi: tanggalRegistrasi ?? this.tanggalRegistrasi,
    );
  }
}
