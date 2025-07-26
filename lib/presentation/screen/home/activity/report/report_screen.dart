import 'package:desklab/presentation/widgets/report_tab_view.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Laporan',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          leading: const BackButton(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [Tab(text: 'Mingguan'), Tab(text: 'Bulanan')],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportTabView(isWeekly: true),
            ReportTabView(isWeekly: false),
          ],
        ),
      ),
    );
  }
}
