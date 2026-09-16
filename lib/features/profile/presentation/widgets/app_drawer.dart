import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onLoginLocal;
  final VoidCallback onLoginGmail;
  final VoidCallback onLoginApple;
  final VoidCallback onShowDailySchedule;
  final VoidCallback onShowWeeklySchedule;
  final VoidCallback onConfigureAvailability;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    required this.onLoginLocal,
    required this.onLoginGmail,
    required this.onLoginApple,
    required this.onShowDailySchedule,
    required this.onShowWeeklySchedule,
    required this.onConfigureAvailability,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Tennis Scheduler',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Panel de Control', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // --- SI ESTÁ LOGUEADO, MOSTRAMOS EL BOTÓN DE CERRAR SESIÓN ---
          if (onLogout != null) ...[
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                onLogout!();            // Ejecuta la función de cierre de sesión
              },
            ),
            const Divider(),
          ],

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Autenticación', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.email, size: 28, color: Colors.blueGrey),
            title: const Text('Iniciar sesión con Contraseña'),
            onTap: () {
              Navigator.pop(context);
              onLoginLocal();
            },
          ),
          ListTile(
            leading: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
            title: const Text('Iniciar sesión con Gmail'),
            onTap: () {
              Navigator.pop(context);
              onLoginGmail();
            },
          ),
          ListTile(
            leading: const Icon(Icons.apple, size: 28),
            title: const Text('Iniciar sesión con iOS (Apple)'),
            onTap: () {
              Navigator.pop(context);
              onLoginApple();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Configuración', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.settings_accessibility),
            title: const Text('Configurar Horarios Laborales'),
            onTap: () {
              Navigator.pop(context);
              onConfigureAvailability();
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Reportes y Planillas', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Planilla del Día'),
            onTap: () {
              Navigator.pop(context);
              onShowDailySchedule();
            },
          ),
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Planilla Semanal Completa'),
            onTap: () {
              Navigator.pop(context);
              onShowWeeklySchedule();
            },
          ),
        ],
      ),
    );
  }
}