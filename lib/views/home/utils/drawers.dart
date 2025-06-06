import 'package:area_control/core/utils/colors.dart';
import 'package:area_control/utils/headline.dart';
import 'package:flutter/material.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 8),
            leading: const Icon(Icons.dashboard_rounded, color: appWhite),
            title: const Headline('Dashboard'),
            onTap: () {
              // Handle home tap
            },
          ),
          _buildtile("Area Control", Icons.polyline_rounded),
          _buildtile("Stops", Icons.multiple_stop_rounded),
          _buildtile("Buses", Icons.bubble_chart_sharp),
        ],
      ),
    );
  }

  ListTile _buildtile(String title, IconData icon) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 8),
      leading: Icon(icon, color: appWhite),
      title: Headline(title),
      onTap: () {
        // Handle home tap
      },
    );
  }
}
