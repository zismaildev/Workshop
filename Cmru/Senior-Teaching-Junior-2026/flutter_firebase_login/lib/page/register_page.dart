import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ดึงระบบ Auth มาใช้

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ')),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'เกิดข้อผิดพลาด: ${e.message}';
        if (e.code == 'weak-password') {
          errorMessage = 'รหัสผ่านอ่อนเกินไป (ต้อง 6 ตัวอักษรขึ้นไป)';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'อีเมลนี้มีคนใช้งานแล้ว';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'ใส่อีเมลของคุณ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'ตั้งรหัสผ่าน (6 ตัวขึ้นไป)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'ยืนยันการสมัคร',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
