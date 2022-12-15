import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_vishu/menu/menu_card.dart';
import 'package:salon_vishu/river_pods/river_pod.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuProvider = ref.watch(menuPageProvider);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: PreferredSize(
          preferredSize: const Size(
            double.infinity,
            56.0,
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                backgroundColor: const Color.fromARGB(20, 200, 200, 200),
                title: const Text('salon "vishu"',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                leading: const Icon(Icons.chevron_left),
                elevation: 0.0,
              ),
            ),
          ),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return MenuCard(isForAll: true);
            }));
  }
}
