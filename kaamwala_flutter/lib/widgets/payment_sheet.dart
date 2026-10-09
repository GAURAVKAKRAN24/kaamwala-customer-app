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
  bool _useWalletDiscount = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    const int visitFee = 199;
    const int repairAmount = 1200;
    const int platformFee = 49;
    final int discount = _useWalletDiscount ? 49 : 0;
    final int total = visitFee + repairAmount + platformFee - discount;
    final walletBal = widget.appState.walletBalance;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E4E7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long, color: Color(0xFF0F766E), size: 22),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Itemized Bill Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF71717A)),
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
                  // Itemized Bill Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      children: [
                        _buildBillRow('Visit & Inspection Charge', '₹$visitFee'),
                        const SizedBox(height: 10),
                        _buildBillRow('AC Deep Jet Wash & Repair', '₹$repairAmount'),
                        const SizedBox(height: 10),
                        _buildBillRow('KaamWala Platform Fee', '₹$platformFee'),
                        const SizedBox(height: 10),
                        if (_useWalletDiscount) ...[
                          _buildBillRow('Wallet Cashback Discount', '-₹$discount', isDiscount: true),
                          const SizedBox(height: 10),
                        ],
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Net Payable Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Includes 30-Day Guarantee', style: TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                              ],
                            ),
                            Text(
                              '₹$total',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Wallet Balance & Discount Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Color(0xFF0F766E), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KaamWala Wallet (₹${walletBal.toStringAsFixed(0)})',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E), fontSize: 13),
                              ),
                              const Text('Apply ₹49 credit discount on this order', style: TextStyle(fontSize: 11, color: Color(0xFF115E59))),
                            ],
                          ),
                        ),
                        Switch(
                          value: _useWalletDiscount,
                          activeColor: const Color(0xFF0F766E),
                          onChanged: (val) => setState(() => _useWalletDiscount = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Select Payment Option', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF18181B))),
                  const SizedBox(height: 10),

                  // UPI Radio
                  _buildPaymentOption(
                    id: 'upi',
                    title: 'UPI (Google Pay, PhonePe, Paytm)',
                    subtitle: 'Instant & zero convenience fee',
                    icon: Icons.qr_code,
                  ),
                  const SizedBox(height: 10),

                  // Wallet Full Pay (if balance sufficient)
                  _buildPaymentOption(
                    id: 'wallet',
                    title: 'KaamWala Wallet Balance',
                    subtitle: 'Available: ₹${walletBal.toStringAsFixed(0)} • 1-tap deduction',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 10),

                  // Card
                  _buildPaymentOption(
                    id: 'card',
                    title: 'Credit / Debit Card / Net Banking',
                    subtitle: 'Visa, MasterCard, Rupay, SBI, HDFC',
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 10),

                  // Cash
                  _buildPaymentOption(
                    id: 'cash',
                    title: 'Cash on Completion',
                    subtitle: 'Pay directly to technician after satisfaction',
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
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : () {
                        setState(() => _isProcessing = true);
                        Future.delayed(const Duration(milliseconds: 900), () {
                          if (mounted) {
                            widget.appState.payBill(_selectedMethod);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text('Payment of ₹$total Successful! 30-Day Warranty activated.'),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF0F766E),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF3F3F46))),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDiscount ? const Color(0xFF0F766E) : const Color(0xFF18181B),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;

    return InkWell(
      onTap: () => setState(() => _selectedMethod = id),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF71717A)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedMethod,
              activeColor: const Color(0xFF0F766E),
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
