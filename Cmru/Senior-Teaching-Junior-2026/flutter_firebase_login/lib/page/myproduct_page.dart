import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/page/editproduct.dart';
import 'addproduct.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ดึง Email ของผู้ที่กำลังใช้งานแอปอยู่ปัจจุบัน
    // เพื่อใช้เป็นเงื่อนไขในการดึงข้อมูล (Query) เฉพาะของตัวเอง
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สินค้าของฉัน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      // 2. StreamBuilder: ตัวรับส่งข้อมูลแบบ Real-time
      // ถ้ามีการลบ หรือเพิ่มสินค้า ข้อมูลในหน้านี้จะอัปเดตเองทันที
      body: StreamBuilder<QuerySnapshot>(
        // ดึงข้อมูลจาก Collection 'products'
        // .where: คือการกรองเอาเฉพาะเอกสารที่ฟิลด์ 'sellerEmail' ตรงกับ Email ของเรา
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('sellerEmail', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          // กรณีเกิด Error ในการเชื่อมต่อ
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          }

          // ระหว่างรอข้อมูลโหลดจากฐานข้อมูล Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. แปลงข้อมูลที่ได้จาก Firebase มาเก็บไว้ในตัวแปร docs (เป็น List)
          final docs = snapshot.data!.docs;

          // ถ้าดึงข้อมูลมาแล้วไม่มีสินค้าเลย (รายการว่างเปล่า)
          if (docs.isEmpty) {
            return const Center(child: Text('คุณยังไม่ได้ลงขายสินค้า'));
          }

          // 4. แสดงรายการสินค้าในรูปแบบรายการ (ListView)
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // ดึงข้อมูลรายชิ้นออกมาในรูปแบบ Map (Key: Value)
              final data = docs[index].data() as Map<String, dynamic>;
              // เก็บ ID ของเอกสารนั้นๆ ไว้สำหรับใช้อ้างอิงตอนสั่ง "ลบ"
              final docId = docs[index].id;

              return ListTile(
                // แสดงรูปภาพจิ๋ว (ถ้าไม่มีรูปให้ขึ้นไอคอนรูปภาพแทน)
                leading: data['imageUrl'] != ""
                    ? Image.network(
                        data['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),
                title: Text(data['name'] ?? 'ไม่มีชื่อ'),
                subtitle: Text('฿${data['price']}'),
                // ปุ่มถังขยะสำหรับลบสินค้า
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProduct(
                              docId: docId,
                              currentName: data['name'] ?? 'ไม่มีชื่อ',
                              currentPrice: data['price'] ?? 0,
                              currentImageUrl: data['imageUrl'] ?? '',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),

                    IconButton(
                      onPressed: () {
                        // เมื่อกด ให้เรียกฟังก์ชันแจ้งเตือนเพื่อยืนยันการลบ
                        _showDeleteDialog(context, docId);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // ปุ่มลอยด้านล่างสำหรับกดไปหน้า "ลงขายสินค้าใหม่"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addproduct()),
          );
        },
        label: const Text('เพิ่มสินค้า'),
        icon: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  // --- ส่วนของฟังก์ชันแจ้งเตือน (Dialog) ---
  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบสินค้า?'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้'),
        actions: [
          // ปุ่มยกเลิก: กดแล้วแค่ปิดหน้าต่างแจ้งเตือน
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          // ปุ่มยืนยันการลบ
          TextButton(
            onPressed: () async {
              // สั่งไปยัง Firebase Firestore ให้ลบเอกสาร (Document) ตาม ID ที่ระบุ
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(docId)
                  .delete();
              // ลบเสร็จแล้วให้ปิดหน้าต่างแจ้งเตือน
              Navigator.pop(context);
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
