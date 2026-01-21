import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../../data/repositories/book_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isAuthenticated) {
            return const Center(
              child: Text('الرجاء تسجيل الدخول'),
            );
          }

          final user = authProvider.currentUser!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: user.photoURL == null
                      ? Text(
                          user.displayName.isNotEmpty
                              ? user.displayName[0]
                              : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : null,
                ),
                
                const SizedBox(height: 16),
                
                // Name
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                
                const SizedBox(height: 8),
                
                // Email
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: 8),
                
                // Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: user.isAdmin
                        ? AppColors.secondaryColor.withOpacity(0.2)
                        : AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.isAdmin ? 'مدير' : 'مستخدم',
                    style: TextStyle(
                      color: user.isAdmin
                          ? AppColors.secondaryColor
                          : AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Bio (if exists)
                if (user.bio != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.bio!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      context,
                      'الكتب المشتراة',
                      '${user.totalPurchases ?? 0}',
                      Icons.book,
                    ),
                    _buildStatCard(
                      context,
                      'التقييمات',
                      '0',
                      Icons.star,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                ListTile(
                  leading: const Icon(Icons.edit, color: AppColors.primaryColor),
                  title: const Text('تعديل الملف الشخصي'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.grey[100],
                ),
                
                const SizedBox(height: 12),
                
                ListTile(
                  leading: const Icon(Icons.settings, color: AppColors.primaryColor),
                  title: const Text('الإعدادات'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.grey[100],
                ),
                
                const SizedBox(height: 12),
                
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.errorColor),
                  title: const Text('تسجيل الخروج'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تسجيل الخروج'),
                        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.errorColor,
                            ),
                            child: const Text('تسجيل الخروج'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await authProvider.signOut();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: AppColors.errorColor.withOpacity(0.1),
                ),
                
                const SizedBox(height: 24),
                
                // Admin Area (Temporary for Seeding)
                if (true) ...[
                  const Divider(),
                  Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('منطقة الإدارة', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                    title: const Text('إضافة بيانات تجريبية (Seed Data)'),
                    onTap: () async {
                       try {
                         final bookRepository = BookRepository();
                         await bookRepository.seedBooks();
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('تمت إضافة البيانات بنجاح')),
                         );
                       } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('خطأ: $e')),
                         );
                       }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.blue.withOpacity(0.1),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
