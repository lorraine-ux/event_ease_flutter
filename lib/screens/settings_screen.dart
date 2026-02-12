import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = NotificationService.instance.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('APPARENCE'),
          _buildSettingTile(
            context,
            icon: Icons.dark_mode,
            iconColor: Colors.deepPurpleAccent,
            title: 'Mode sombre',
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionHeader('NOTIFICATIONS'),
          _buildSettingTile(
            context,
            icon: Icons.notifications_active,
            iconColor: Colors.redAccent,
            title: 'Rappels d\'événements',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (val) async {
                setState(() {
                  _notificationsEnabled = val;
                });
                await NotificationService.instance.enableNotifications(val);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val 
                        ? 'Notifications activées' 
                        : 'Notifications désactivées'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              activeColor: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('DONNÉES'),
          _buildSettingTile(
            context,
            icon: Icons.delete_forever,
            iconColor: Colors.orange,
            title: 'Effacer les données',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _confirmDelete(context),
          ),

          const SizedBox(height: 24),
          
          _buildSectionHeader('À PROPOS'),
          _buildSettingTile(
            context,
            icon: Icons.info_outline,
            iconColor: Colors.pinkAccent,
            title: 'Version',
            trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('COMPTE'),
          _buildSettingTile(
            context,
            icon: Icons.logout,
            iconColor: Colors.redAccent,
            title: 'Déconnexion',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Effacer toutes les données ?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Cette action est irréversible. Tous vos événements seront supprimés.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false).deleteAllEvents();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Données effacées')),
              );
            },
            child: const Text('Effacer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              if (mounted) {
                Navigator.pop(ctx);
                // Rediriger vers la page de connexion
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion réussie')),
                );
              }
            },
            child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
