import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isTeacher;
  final bool isGridPage;
  final VoidCallback? onLoginLocal;
  final VoidCallback? onShowDailySchedule;
  final VoidCallback? onShowWeeklySchedule;
  final VoidCallback? onConfigureAvailability;
  final VoidCallback? onShowGridPage;
  final VoidCallback? onBackToList;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.isTeacher,
    this.isGridPage = false,
    this.onLoginLocal,
    this.onShowDailySchedule,
    this.onShowWeeklySchedule,
    this.onConfigureAvailability,
    this.onShowGridPage,
    this.onBackToList,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // --- BOTÓN DINÁMICO ---
          ListTile(
            leading: Icon(isGridPage ? Icons.list_alt : Icons.grid_view),
            title: Text(isGridPage ? 'Lista' : 'Grilla Semanal'),
            onTap: () {
              Navigator.pop(context); // Cierra el menú lateral
              if (isGridPage) {
                if (onBackToList != null) {
                  onBackToList!();
                } else {
                  Navigator.pop(context);
                }
              } else {
                if (onShowGridPage != null) onShowGridPage!();
              }
            },
          ),
          // --------------------

          if (isTeacher) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Panel de Profesor', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Planilla del Día'),
              onTap: () {
                Navigator.pop(context);
                if (onShowDailySchedule != null) onShowDailySchedule!();
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Planilla Semanal Completa'),
              onTap: () {
                Navigator.pop(context);
                if (onShowWeeklySchedule != null) onShowWeeklySchedule!();
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Configurar Horarios Laborales'),
              onTap: () {
                Navigator.pop(context);
                if (onConfigureAvailability != null) onConfigureAvailability!();
              },
            ),
          ],

          const Divider(),

          if (onLogout != null)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onLogout!();
              },
            ),
        ],
      ),
    );
  }
}