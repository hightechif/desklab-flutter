import 'package:desklab/domain/models/employee.dart';
import 'package:desklab/presentation/screen/employee/employee_detail_screen.dart';
import 'package:flutter/material.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _searchController = TextEditingController();
  late Map<String, List<Employee>> _allEmployees;
  Map<String, List<Employee>> _filteredEmployees = {};

  @override
  void initState() {
    super.initState();
    _allEmployees = {
      'Mobile Engineering': [
        Employee(
          name: 'Abraham Wong',
          title: 'Mobile Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=AW',
          phone: '081234567890',
          email: 'abraham.wong@sg-edts.com',
          employeeId: 'EDTS022189',
          department: 'Product Development & Operation',
          division: 'Mobile Engineering',
          joinDate: '10 Jan 2023',
        ),
        Employee(
          name: 'Hafshy Yazid Albisthami',
          title: 'Associate Mobile Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=HY',
          phone: '085795395767',
          email: 'hafshy.yazid@sg-edts.com',
          employeeId: 'EDTS90247',
          department: 'Product Development & Operation',
          division: 'Mobile Engineering',
          joinDate: '8 Januari 2024',
        ),
      ],
      'Data Science & Analytics': [
        Employee(
          name: 'Shafa Az Zahra',
          title: 'Data Analyst Associate',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=SZ',
          phone: '081234567892',
          email: 'shafa.zahra@sg-edts.com',
          employeeId: 'EDTS022191',
          department: 'Data',
          division: 'Data Science & Analytics',
          joinDate: '12 Mar 2023',
        ),
      ],
      'Frontend Engineering': [
        Employee(
          name: 'Mohammad Hafidh Wildan M',
          title: 'Associate Frontend Engineer',
          imageUrl: 'https://placehold.co/100x100/EFEFEF/333333?text=MW',
          phone: '081234567893',
          email: 'hafidh.wildan@sg-edts.com',
          employeeId: 'EDTS022192',
          department: 'Product Development & Operation',
          division: 'Frontend Engineering',
          joinDate: '15 Apr 2023',
        ),
      ],
    };
    _filteredEmployees = _allEmployees;
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = _allEmployees;
      } else {
        _filteredEmployees = {};
        _allEmployees.forEach((department, employees) {
          final filteredList =
              employees
                  .where(
                    (employee) => employee.name.toLowerCase().contains(query),
                  )
                  .toList();
          if (filteredList.isNotEmpty) {
            _filteredEmployees[department] = filteredList;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Karyawan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Karyawan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredEmployees.keys.length,
        itemBuilder: (context, index) {
          final department = _filteredEmployees.keys.elementAt(index);
          final employeeList = _filteredEmployees[department]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  department,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employeeList.length,
                itemBuilder: (context, empIndex) {
                  final employee = employeeList[empIndex];
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EmployeeDetailScreen(employee: employee),
                          ),
                        ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(employee.imageUrl),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                employee.title,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
