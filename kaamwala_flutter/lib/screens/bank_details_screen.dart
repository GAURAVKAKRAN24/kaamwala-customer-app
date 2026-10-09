import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../services/app_state.dart';

class BankDetailsScreen extends StatefulWidget {
  final AppState appState;

  const BankDetailsScreen({super.key, required this.appState});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddBankAccountSheet() {
    final holderCtrl = TextEditingController(text: widget.appState.currentUser.name);
    final bankCtrl = TextEditingController();
    final accCtrl = TextEditingController();
    final ifscCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE4E4E7), borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Bank Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Used for instant 100% refund processing on cancellations',
                style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: holderCtrl,
                decoration: InputDecoration(
                  labelText: 'Account Holder Name',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bankCtrl,
                decoration: InputDecoration(
                  labelText: 'Bank Name (e.g. HDFC, SBI, ICICI)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: accCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ifscCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'IFSC Code (11 digits)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (holderCtrl.text.trim().isEmpty || accCtrl.text.trim().isEmpty || ifscCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all required details')),
                      );
                      return;
                    }
                    widget.appState.addBankAccount(
                      BankAccount(
                        id: 'bnk_${DateTime.now().millisecondsSinceEpoch}',
                        bankName: bankCtrl.text.trim().isEmpty ? 'Bank Account' : bankCtrl.text.trim(),
                        accountNumber: accCtrl.text.trim(),
                        ifscCode: ifscCtrl.text.trim().toUpperCase(),
                        holderName: holderCtrl.text.trim(),
                        isPrimary: widget.appState.bankAccounts.isEmpty,
                      ),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bank account added successfully!'),
                        backgroundColor: Color(0xFF0F766E),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save Bank Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddUpiSheet() {
    final upiCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE4E4E7), borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add UPI ID (VPA)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF18181B)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Instant payout destination for referral cashbacks and refunds',
                style: TextStyle(fontSize: 12, color: Color(0xFF71717A)),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: upiCtrl,
                decoration: InputDecoration(
                  labelText: 'UPI ID (e.g. mobile@paytm or name@okhdfcbank)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final upi = upiCtrl.text.trim();
                    if (!upi.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid UPI ID with @ symbol')),
                      );
                      return;
                    }
                    widget.appState.addSavedUpi(
                      SavedUpi(
                        id: 'upi_${DateTime.now().millisecondsSinceEpoch}',
                        upiId: upi,
                        provider: upi.contains('okhdfc') || upi.contains('oksbi') ? 'Google Pay' : 'UPI VPA',
                        isDefault: widget.appState.savedUpis.isEmpty,
                      ),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('UPI ID verified and saved!'),
                        backgroundColor: Color(0xFF0F766E),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Verify & Save UPI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = widget.appState.bankAccounts;
    final upis = widget.appState.savedUpis;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Bank & Refund Accounts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF18181B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Security disclaimer banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF0FDFA),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF0F766E), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bank and UPI details are encrypted and strictly used for refunds and wallet withdrawals.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF115E59)),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0F766E),
              indicatorWeight: 3,
              labelColor: const Color(0xFF0F766E),
              unselectedLabelColor: const Color(0xFF71717A),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'Bank Accounts'),
                Tab(text: 'Saved UPI IDs'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Bank Accounts List
                _buildBankAccountsList(accounts),

                // UPI List
                _buildUpisList(upis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountsList(List<BankAccount> accounts) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...accounts.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: b.isPrimary ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance, color: Color(0xFF0F766E), size: 22),
                        const SizedBox(width: 8),
                        Text(b.bankName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    if (b.isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('PRIMARY', style: TextStyle(color: Color(0xFF0F766E), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(b.maskedNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('IFSC: ${b.ifscCode}', style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                    Text('A/C: ${b.holderName}', style: const TextStyle(fontSize: 12, color: Color(0xFF71717A))),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _showAddBankAccountSheet,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Another Bank Account'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0F766E),
            side: const BorderSide(color: Color(0xFF0F766E)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildUpisList(List<SavedUpi> upis) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...upis.map((u) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: u.isDefault ? const Color(0xFF0F766E) : const Color(0xFFE4E4E7)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0FDFA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.qr_code, color: Color(0xFF0F766E), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.upiId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(u.provider, style: const TextStyle(fontSize: 11, color: Color(0xFF71717A))),
                      ],
                    ),
                  ],
                ),
                if (u.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('DEFAULT', style: TextStyle(color: Color(0xFF0F766E), fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          );
        }),

        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _showAddUpiSheet,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New UPI ID'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0F766E),
            side: const BorderSide(color: Color(0xFF0F766E)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
