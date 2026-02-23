import 'package:flutter/material.dart';
import '../controllers/bid_controller.dart';

class BidInputCard extends StatelessWidget {
  final BidController controller;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final int index;
  final bool canRemove;

  const BidInputCard({
    super.key,
    required this.controller,
    required this.onRemove,
    required this.onAdd,
    required this.index,
    required this.canRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.companyController,
              decoration: InputDecoration(
                labelText: 'نام شرکت ${index + 1}',
                hintText: 'مثال: تیک آب سازه آذربایجان',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.business, color: Color(0xFF1E3A8A)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.priceController,
              decoration: InputDecoration(
                labelText: 'مبلغ پیشنهاد (ریال)',
                hintText: 'مثال: 59600000000',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              keyboardType: TextInputType.number,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (canRemove)
                  TextButton.icon(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('حذف', style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(width: 8),
                if (index == controller.parentIndex && controller.parentLength < 20)
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('افزودن', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}