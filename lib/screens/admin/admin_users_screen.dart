import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'usr_101',
      'name': 'Ali Hassan',
      'email': 'ali.hassan@university.edu.pk',
      'phone': '+923001234567',
      'role': 'Student',
      'active': true,
    },
    {
      'id': 'usr_102',
      'name': 'Sara Ahmed',
      'email': 'sara.ahmed@university.edu.pk',
      'phone': '+923019876543',
      'role': 'Student',
      'active': true,
    },
    {
      'id': 'usr_103',
      'name': 'Dr. Tariq Mahmood',
      'email': 'tariq.mahmood@university.edu.pk',
      'phone': '+923334445566',
      'role': 'Faculty',
      'active': true,
    },
    {
      'id': 'usr_104',
      'name': 'Usman Khan',
      'email': 'usman.k@university.edu.pk',
      'phone': '+923215556677',
      'role': 'Student',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registered Campus Users'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final u = _users[index];
            final isActive = u['active'] as bool;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.secondary.withOpacity(0.15),
                    child: Text(
                      (u['name'] as String)[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${u['email']} • ${u['role']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        Text(
                          u['phone'],
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        isActive ? 'Active' : 'Blocked',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? AppColors.successGreen : AppColors.errorRed,
                        ),
                      ),
                      Switch(
                        value: isActive,
                        activeTrackColor: AppColors.successGreen,
                        onChanged: (val) {
                          setState(() {
                            _users[index]['active'] = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
