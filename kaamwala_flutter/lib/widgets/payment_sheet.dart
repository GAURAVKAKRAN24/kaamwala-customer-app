import 'package:flutter/material.dart';
import '../services/app_state.dart';

class PaymentSheet extends StatefulWidget {
  final AppState appState;

  const PaymentSheet({
    super.key,
    required this.appState,
  });

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  String _selectedMethod = 'upi';
  bool _couponApplied = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    const int visitFee = 199;
    const int serviceAmount = 499;
    const int partsAmount = 200;
    final int discount = _couponApplied ? 100 : 0;
    final int subtotal = serviceAmount + partsAmount;
    final int gst = ((subtotal - discount) * 0.18).round();
    final int total = subtotal - discount + gst;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Color(0xFF059669), size: 26),
                const SizedBox(width: 10),
                const Text(
                  'Authoritative Bill Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice summary box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildBillRow('Visit & Diagnosis Fee', '₹$visitFee', isStrikethrough: true, note: 'Adjusted in final work'),
                        const SizedBox(height: 10),
                        _buildBillRow('AC Deep Jet Cleaning', '₹$serviceAmount'),
                        const SizedBox(height: 10),
                        _buildBillRow('Copper Flare Nut Spare', '₹$partsAmount'),
                        const SizedBox(height: 10),
                        if (_couponApplied) ...[
                          _buildBillRow('Coupon FIRST100', '-₹$discount', isDiscount: true),
                          const SizedBox(height: 10),
                        ],
                        _buildBillRow('GST (18% Govt. Tax)', '₹$gst'),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Amount Payable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Inclusive of all taxes & warranty', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            Text(
                              '₹$total',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Coupon card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.discount, color: Color(0xFF059669), size: 20),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FIRST100 Applied', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                              Text('Flat ₹100 discount on your first order', style: TextStyle(fontSize: 11, color: Color(0xFF047857))),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _couponApplied = !_couponApplied),
                          child: Text(_couponApplied ? 'Remove' : 'Apply', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Select Payment Option', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),

                  // UPI
                  _buildPaymentRadio(
                    value: 'upi',
                    title: 'UPI (Instant & Zero Fee)',
                    subtitle: 'Google Pay, PhonePe, Paytm, BHIM',
                    icon: Icons.account_balance_wallet,
                  ),
                  const SizedBox(height: 8),

                  // Card
                  _buildPaymentRadio(
                    value: 'card',
                    title: 'Credit / Debit Card',
                    subtitle: 'Visa, MasterCard, Rupay',
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 8),

                  // Cash
                  _buildPaymentRadio(
                    value: 'cash',
                    title: 'Cash on Completion',
                    subtitle: 'Handover cash directly to technician',
                    icon: Icons.payments_outlined,
                  ),
                ],
              ),
            ),
          ),

          // Footer Pay Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -4)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : () {
                        setState(() => _isProcessing = true);
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          if (mounted) {
                            widget.appState.completePayment(_selectedMethod);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment of ₹725 Successful! Invoice sent to your email & SMS.'),
                                backgroundColor: Color(0xFF059669),
                              ),
                            );
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Pay ₹$total securely via ${_selectedMethod.toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isStrikethrough = false, bool isDiscount = false, String? note}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
            if (note != null)
              Text(note, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
            color: isStrikethrough
                ? Colors.grey
                : (isDiscount ? const Color(0xFF059669) : const Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRadio({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == value;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF059669) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF059669) : Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedMethod,
              activeColor: const Color(0xFF059669),
              onChanged: (val) {
                if (val != null) setState(() => _selectedMethod = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
