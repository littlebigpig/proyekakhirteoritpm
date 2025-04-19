class Situs {
  final String nama;
  final String deskripsi;
  final String image;
  bool isFavorite;
  final String url;

  Situs({
    required this.nama,
    required this.deskripsi,
    required this.image,
    this.isFavorite = false,
    required this.url,
  });

  Situs copyWith({
    String? nama,
    String? deskripsi,
    String? image,
    bool? isFavorite,
    String? url,
  }) {
    return Situs(
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      url: url ?? this.url,
    );
  }
}
