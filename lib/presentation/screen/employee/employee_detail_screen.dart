import 'package:desklab/domain/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Karyawan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
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
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(employee.imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            employee.title,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildProfileDetailRow(Icons.phone, 'Telepon', employee.phone),
                _buildProfileDetailRow(Icons.email, 'Email', employee.email),
                _buildProfileDetailRow(
                  Icons.badge,
                  'ID Karyawan',
                  employee.employeeId,
                ),
                _buildProfileDetailRow(
                  Icons.business,
                  'Departemen',
                  employee.department,
                ),
                _buildProfileDetailRow(
                  Icons.group_work,
                  'Divisi',
                  employee.division,
                ),
                _buildProfileDetailRow(
                  Icons.calendar_today,
                  'Tanggal Bergabung',
                  employee.joinDate,
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
