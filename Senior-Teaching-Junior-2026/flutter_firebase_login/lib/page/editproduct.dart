import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  final String docId;
  final String currentName;
  final int currentPrice;
  final String currentImageUrl;

  const EditProduct({
    super.key,
    required this.docId,
    required this.currentName,
    required this.currentPrice,
    required this.currentImageUrl,
  });

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  File? _image; // ตัวแปรสำหรับเก็บภาพที่เลือก
  bool _isLoading = false; // ตัวแปรสำหรับแสดงสถานะการโหลด

  // ข้อมูลสำหรับ Cloudinary
  final String cloudName = '#'; // ชื่อ Cloudinary ของคุณ
  final String uploadPreset = '#'; // Upload preset ของคุณ

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _priceController = TextEditingController(
      text: widget.currentPrice.toString(),
    );
  }

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

  // ฟังก์ชันสำหรับอัปเดตข้อมูล
  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')));
      return;
    }

    setState(() => _isLoading = true);

    String finalImageUrl = widget.currentImageUrl; // ใช้รูปเดิมเป็นค่าเริ่มต้น

    // ถ้ามีการเลือกรูปใหม่ ให้ทำการอัปโหลดก่อน
    if (_image != null) {
      String? uploadedUrl = await _uploadToCloudinary(_image!);
      if (uploadedUrl != null) {
        finalImageUrl = uploadedUrl;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('อัปโหลดรูปภาพล้มเหลว')));
        setState(() => _isLoading = false);
        return;
      }
    }

    try {
      // อัปเดตข้อมูลใน Firestore โดยอ้างอิงจาก docId
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .update({
            'name': _nameController.text,
            'price': int.parse(_priceController.text),
            'imageUrl': finalImageUrl,
            'updatedAt': Timestamp.now(), // เก็บเวลาที่แก้ไข
          });

      if (mounted) Navigator.pop(context); // กลับไปหน้าก่อนหน้า
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แก้ไขสินค้า",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
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
                      child: _image != null
                          // กรณีที่ 1: เลือกรูปใหม่แล้ว → แสดงรูปใหม่
                          ? Image.file(_image!, fit: BoxFit.cover)
                          // กรณีที่ 2: ยังไม่เลือกรูปใหม่ แต่มีรูปเดิม → แสดงรูปเดิม
                          : widget.currentImageUrl.isNotEmpty
                          ? Image.network(
                              widget.currentImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                            )
                          // กรณีที่ 3: ไม่มีรูปเลย → แสดงไอคอน
                          : Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey[700],
                            ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  const Text(
                    "แตะที่กรอบด้านบนเพื่อเปลี่ยนรูปภาพ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
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
                      onPressed: _updateProduct, // ฟังก์ชันสำหรับบันทึกสินค้า
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurpleAccent, // เปลี่ยนสีปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // ปรับมุมปุ่มให้โค้งขึ้น
                        ),
                      ), // ฟังก์ชันสำหรับบันทึกสินค้า
                      child: Text(
                        "บันทึกการแก้ไข",
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
