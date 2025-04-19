import 'package:flutter/material.dart';
import 'package:tugas2teori/page/anggota.dart';
import 'package:tugas2teori/page/bantuan.dart';
import 'package:tugas2teori/page/home.dart';
import 'package:tugas2teori/page/info.dart';
import 'package:tugas2teori/page/situs_favorit.dart';
import 'package:tugas2teori/page/situs_rekomendasi.dart';
import 'package:tugas2teori/page/tracking_lbs.dart';
import 'package:tugas2teori/page/stopwatch.dart';
import 'package:tugas2teori/page/konversiwaktu.dart';
import 'package:tugas2teori/page/jenisbilangan.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:tugas2teori/page/splash_screen.dart';
import 'package:tugas2teori/page/login.dart';
import 'package:go_router/go_router.dart';
import '../layout/layout_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.SplashScreen,
  routes: [
    GoRoute(
      path: Routes.SplashScreen,
      builder: (context, state) => SplashScreen(),
      ),
    GoRoute(
      path: Routes.Login,
      builder: (context, state) => LoginScreen(),
      ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              LayoutScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.HomePage,
              builder: (context, state) => HomePage(),
              routes: [
                GoRoute(
                  path: Routes.SitusRekomendasi,
                  builder: (context, state) => SitusRekomendasi(),
                  routes: [
                    GoRoute(
                      path: Routes.SitusFavorit,
                      builder: (context, state) => SitusFavorit(),
                    ),
                  ],
                ),
                GoRoute(
                  path: Routes.Stopwatch,
                  builder: (context, state) => CountdownPage(),
                ),
                GoRoute(
                  path: Routes.MapSample,
                  builder: (context, state) => MapSample(),
                ),
                GoRoute(
                  path: Routes.JenisBilangan,
                  builder: (context, state) => JenisBilanganPage(),
                ),
                GoRoute(
                  path: Routes.KonversiWaktu,
                  builder: (context, state) => KonversiWaktuPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.AnggotaPage,
              builder: (context, state) => AnggotaPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.InfoPage,
              builder: (context, state) => InfoPage(),
              routes: [
                GoRoute(
                  path: Routes.BantuanPage,
                  builder: (context, state) => BantuanPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
