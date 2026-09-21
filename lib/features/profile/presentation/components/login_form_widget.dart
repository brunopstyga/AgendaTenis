import 'package:flutter/material.dart';

class LoginFormWidget extends StatefulWidget {
  final bool isRegistering;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  const LoginFormWidget({
    super.key,
    required this.isRegistering,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.isLoading,
    required this.onSubmit,
    required this.onToggleMode,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isRegistering) ...[
                TextField(
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre (Opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: widget.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (widget.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: widget.onSubmit,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,),
                  child: Text(widget.isRegistering ? 'Registrarse' : 'Ingresar'),
                ),
              TextButton(
                onPressed: widget.onToggleMode,
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: Text(
                  widget.isRegistering
                      ? '¿Ya tienes una cuenta? Inicia sesión'
                      : '¿No tienes cuenta? Regístrate aquí',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}