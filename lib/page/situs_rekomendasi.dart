import 'package:flutter/material.dart';
import 'package:tugas2teori/models/daftar_situs.dart';
import 'package:tugas2teori/models/situs.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SitusRekomendasi extends StatelessWidget {
  const SitusRekomendasi({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarSitus = context.watch<DaftarSitus>().daftarsitus;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Situs Rekomendasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            iconSize: 30,
            onPressed: () => context.push(Routes.NestedSitusFavorit),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: daftarSitus.length,
                itemBuilder: (context, index) {
                  final situs = daftarSitus[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CardSitus(situs: situs),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardSitus extends StatelessWidget {
  final Situs situs;

  const CardSitus({super.key, required this.situs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchWebsite(situs.url, context),
      child: SizedBox(
        width: 300,
        child: Card(
          color: const Color.fromARGB(255, 194, 236, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image container
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(situs.image),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child:
                      situs.image.isEmpty
                          ? const Icon(
                            Icons.public,
                            size: 40,
                            color: Colors.grey,
                          )
                          : null,
                ),
                const SizedBox(height: 12),
                Text(
                  situs.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  situs.deskripsi,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 35,
                      icon: Icon(
                        situs.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            situs.isFavorite
                                ? Colors.red
                                : const Color.fromARGB(255, 67, 93, 127),
                      ),
                      onPressed: () => _toggleFavorite(context),
                      padding: EdgeInsets.zero,
                    ),
                    FilledButton.icon(
                      onPressed: () => _launchWebsite(situs.url, context),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Visit Website'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    final provider = Provider.of<DaftarSitus>(context, listen: false);
    final index = provider.daftarsitus.indexOf(situs);
    provider.toggleFavorite(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          situs.isFavorite ? 'Ditambahkan ke favorit' : 'Dihapus dari Favorit',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _launchWebsite(String url, BuildContext context) async {
    try {
      if (url.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('URL tidak tersedia')));
        return;
      }

      if (!url.startsWith('http')) {
        url = 'https://$url';
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tidak bisa membuka: $url')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
