import 'package:flutter/material.dart';
import 'package:tugas2teori/page/bantuan.dart';
import 'package:tugas2teori/page/country_detail.dart';
import 'package:tugas2teori/page/countrypage.dart';
import 'package:tugas2teori/page/home.dart';
import 'package:tugas2teori/page/info.dart';
import 'package:tugas2teori/page/tracking_lbs.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:tugas2teori/page/splash_screen.dart';
import 'package:tugas2teori/page/login.dart';
import 'package:go_router/go_router.dart';
import '../layout/layout_scaffold.dart';
import 'package:tugas2teori/page/register.dart';

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
    GoRoute(
      path: Routes.Register,
      builder: (context, state) => RegisterScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          LayoutScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.HomePage,
              builder: (context, state) => HomePage(),
              routes: [
                GoRoute(
                  path: Routes.MapSample,
                  builder: (context, state) => MapSample(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.Country,
              builder: (context, state) => CountryListPage(),
              routes: [
                GoRoute(
                  path: 'detail/:name',
                  builder: (context, state) => CountryDetailPage(
                    countryName: Uri.decodeComponent(state.pathParameters['name'] ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
        /*StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.AnggotaPage,
              builder: (context, state) => AnggotaPage(),
            ),
          ],
        ),*/
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
