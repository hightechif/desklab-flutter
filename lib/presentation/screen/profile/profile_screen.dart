import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://placehold.co/100x100/EFEFEF/333333?text=RF',
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ridhan Fadhilah',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mobile Engineer',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildProfileDetailRow(Icons.phone, 'Telepon', '081220220697'),
                _buildProfileDetailRow(
                  Icons.email,
                  'Email',
                  'ridhan.fadhilah@sg-edts.com',
                ),
                _buildProfileDetailRow(Icons.badge, 'ID Karyawan', 'EDTS90122'),
                _buildProfileDetailRow(
                  Icons.business,
                  'Departemen',
                  'Product Development & Operation',
                ),
                _buildProfileDetailRow(
                  Icons.group_work,
                  'Divisi',
                  'Mobile Engineering',
                ),
                _buildProfileDetailRow(
                  Icons.calendar_today,
                  'Tanggal Bergabung',
                  '5 April 2021',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aset',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildProfileDetailRow(
                  Icons.laptop_mac,
                  'Macbook Pro Touch Bar 13',
                  'EDTS022188',
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_to_queue),
                  label: const Text('Daftarkan Aset'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileDetailRow(IconData icon, String title, String subtitle) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    ),
  );
}
