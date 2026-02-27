import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final _nameController = TextEditingController(); // ตัวควบคุมสำหรับชื่อสินค้า
  final _priceController = TextEditingController(); // ตัวควบคุมสำหรับราคาสินค้า

  File? _image; // ตัวแปรสำหรับเก็บภาพที่เลือก
  bool _isLoading = false; // ตัวแปรสำหรับแสดงสถานะการโหลด

  // ข้อมูลสำหรับ Cloudinary
  final String cloudName = '#'; // ชื่อ Cloudinary ของคุณ
  final String uploadPreset = '#'; // Upload preset ของคุณ

  // ฟังก์ชันสำหรับเลือกภาพจากแกลเลอรี่
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันสำหรับอัปโหลดภาพไปยัง Cloudinary และรับ URL ของภาพ
  Future<String?> _uploadToCloudinary(File imageFile) async {
    // ระบุ URL ของ API Cloudinary
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    // สร้าง Request แบบ Multipart (เหมือนการส่งฟอร์มที่มีไฟล์แนบ)
    var request = http.MultipartRequest("POST", url);
    request.fields['upload_preset'] = uploadPreset; // ส่งรหัสผ่านสำหรับอัปโหลด
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path), // แนบไฟล์รูป
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // ถ้าอัปโหลดสำเร็จ ให้แกะเอา URL ของรูปภาพออกมา
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url']; // ส่งคืน Link รูปที่ดูออนไลน์ได้
      }
    } catch (e) {
      print("Upload Error: $e");
    }
    return null; // ถ้าพลาดส่งค่าว่างกลับไป
  }

  // ฟังก์ชันสำหรับบันทึกสินค้า
  Future<void> _saveProduct() async {
    // ตรวจสอบว่ากรอกข้อมูลครบหรือยัง
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')));
      return;
    }

    setState(() => _isLoading = true); // เริ่มแสดงหน้าจอโหลด

    // ขั้นตอนที่ A: ส่งรูปไปฝากที่ Cloudinary ก่อนเพื่อให้ได้ Link (URL) มา
    String? imageUrl = await _uploadToCloudinary(_image!);

    if (imageUrl != null) {
      // ขั้นตอนที่ B: เมื่อได้ Link รูปมาแล้ว ก็นำ Link นั้นพร้อมชื่อและราคาไปเก็บใน Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'price': int.parse(_priceController.text),
        'imageUrl': imageUrl, // เก็บเป็น Link ตัวอักษร
        'sellerEmail':
            FirebaseAuth.instance.currentUser?.email, // เก็บ Email คนขาย
        'createdAt': Timestamp.now(), // เก็บเวลาที่ลงขาย
      });

      // ถ้าบันทึกเสร็จให้ปิดหน้านี้กลับไปหน้า Home
      if (mounted) Navigator.pop(context);
    } else {
      // แจ้งเตือนถ้าอัปโหลดรูปไม่สำเร็จ
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('อัปโหลดรูปภาพล้มเหลว')));
    }

    setState(() => _isLoading = false); // ปิดการแสดงหน้าจอโหลด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เพิ่มสินค้า",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1, // ลบเงา
        foregroundColor: Colors.black, // เปลี่ยนสีไอคอนและข้อความเป็นสีดำ
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // แสดงตัวโหลดเมื่อกำลังโหลด
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage, // ฟังก์ชันสำหรับเลือกภาพ
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _image == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey[700],
                            )
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // ช่องกรอกชื่อสินค้า
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "ชื่อสินค้า",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // ช่องกรอกราคาสินค้า
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "ราคา",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number, // ใช้คีย์บอร์ดตัวเลข
                  ),
                  SizedBox(height: 16.0),

                  // ปุ่มบันทึกสินค้า
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProduct, // ฟังก์ชันสำหรับบันทึกสินค้า
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // เปลี่ยนสีปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // ปรับมุมปุ่มให้โค้งขึ้น
                        ),
                      ), // ฟังก์ชันสำหรับบันทึกสินค้า
                      child: Text(
                        "บันทึก",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
