import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherNotificationsWidget extends StatelessWidget {
  const TeacherNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('No hay notificaciones nuevas'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: Text(data['title'] ?? 'Aviso'),
              subtitle: Text(data['message'] ?? ''),
              // Puedes agregar un botón para marcar como leído si gustas
            );
          },
        );
      },
    );
  }
}