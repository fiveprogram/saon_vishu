import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_vishu/widget/appBar.dart';
import 'package:salon_vishu/menu/menu_card.dart';
import 'package:salon_vishu/river_pods/river_pod.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuProvider = ref.watch(menuPageProvider);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return MenuCard(isTargetAllMember: true);
            }));
  }
}
