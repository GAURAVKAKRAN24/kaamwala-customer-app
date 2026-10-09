import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'mock_data.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final String time;
  final bool isCustomer;
  final String? mediaUrl;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    required this.isCustomer,
    this.mediaUrl,
  });
}

class AppState extends ChangeNotifier {
  // Onboarding Screen Tracker
  String _currentRoute = 'splash'; // 'splash', 'lang', 'address', 'otp', 'app'

  // Locale (en / hi)
  String _language = 'en';

  // Current Logged In User
  AppUser _currentUser = AppUser(
    id: 'usr_ankit_281',
    name: 'Ankit Verma',
    email: 'ankit@email.com',
    phone: '+91 98765 43210',
    avatar: 'A',
    authProvider: 'phone',
    isAadhaarVerified: true,
    profileCompletion: 40, // Shows Incomplete banner as specified
  );

  // Active Location (Sector 18, Noida default)
  Locality _currentLocality = MockRepository.localities.first;

  // Active Job & History
  CustomerJob _activeJob = MockRepository.createInitialActiveJob();
  final List<CustomerJob> _allJobs = [
    MockRepository.createInitialActiveJob(),
    CustomerJob(
      id: 'KW-28310',
      category: 'plumber',
      serviceName: 'Plumber • Leakage Repair',
      description: 'Kitchen mixer tap washer worn out, dripping continuously.',
      address: 'Sector 18, Noida • 201301',
      date: '18 Dec',
      time: '11:00 AM',
      status: 'WORK_COMPLETED',
      visitFee: 149,
      estimatedAmount: 650,
      finalAmount: 650,
      assignedWorker: MockRepository.workers[1],
    ),
    CustomerJob(
      id: 'KW-28102',
      category: 'electrician',
      serviceName: 'Electrician • Switchboard Fix',
      description: 'MCB tripping fix and living room switchboard replacement.',
      address: 'Sector 18, Noida • 201301',
      date: '12 Dec',
      time: '4:00 PM',
      status: 'CLOSED',
      visitFee: 199,
      estimatedAmount: 450,
      finalAmount: 450,
      assignedWorker: MockRepository.workers[2],
    ),
    CustomerJob(
      id: 'KW-27911',
      category: 'ro',
      serviceName: 'RO Service & Filter Change',
      description: 'Filter membrane change request.',
      address: 'Sector 18, Noida • 201301',
      date: '05 Dec',
      time: '10:00 AM',
      status: 'CANCELLED',
      visitFee: 99,
      estimatedAmount: 0,
      finalAmount: 0,
    ),
  ];

  // In-app Messages
  final List<ChatMessage> _messages = [
    const ChatMessage(
      id: 'm1',
      sender: 'System',
      text: 'Job KW-28491 created. Broadcasting to verified pros within 3km.',
      time: '10:12 AM',
      isCustomer: false,
    ),
    const ChatMessage(
      id: 'm2',
      sender: 'System',
      text: 'Ramesh Kumar accepted your job! Fixed visit charge: ₹199.',
      time: '10:14 AM',
      isCustomer: false,
    ),
    const ChatMessage(
      id: 'm3',
      sender: 'Ramesh Kumar (AC Expert)',
      text: 'Namaste Ankit ji! I am on the way with genuine copper pipe & foam jet wash pump. Reaching in 12 min.',
      time: '10:21 AM',
      isCustomer: false,
    ),
    const ChatMessage(
      id: 'm4',
      sender: 'You',
      text: 'Sure Ramesh ji, gate code is 204. Please call on arrival.',
      time: '10:22 AM',
      isCustomer: true,
    ),
  ];

  // Wallet
  double _walletBalance = 250.0;
  final List<WalletTransaction> _walletTransactions = [
    const WalletTransaction(
      id: 'tx_1',
      type: 'CREDIT',
      amount: 100.0,
      title: 'Referral Bonus (Friend joined)',
      date: '08 Oct 2026, 04:30 PM',
      status: 'SUCCESS',
    ),
    const WalletTransaction(
      id: 'tx_2',
      type: 'DEBIT',
      amount: 49.0,
      title: 'Platform Fee Discount Applied (KW-28491)',
      date: '09 Oct 2026, 10:15 AM',
      status: 'SUCCESS',
    ),
    const WalletTransaction(
      id: 'tx_3',
      type: 'CREDIT',
      amount: 199.0,
      title: 'Wallet Topup via UPI',
      date: '05 Oct 2026, 02:00 PM',
      status: 'SUCCESS',
    ),
  ];

  // Referral Program
  ReferralInfo _referralInfo = const ReferralInfo(
    code: 'ANKIT100',
    rewardPerReferral: 100.0,
    friendDiscount: 100.0,
    totalReferrals: 3,
    totalEarned: 300.0,
  );

  // Notifications
  List<NotificationItem> _notifications = MockRepository.getNotifications();

  // Getters
  String get currentRoute => _currentRoute;
  String get language => _language;
  AppUser get currentUser => _currentUser;
  Locality get currentLocality => _currentLocality;
  CustomerJob get activeJob => _activeJob;
  List<CustomerJob> get allJobs => _allJobs;
  List<ChatMessage> get messages => _messages;
  double get walletBalance => _walletBalance;
  List<WalletTransaction> get walletTransactions => _walletTransactions;
  ReferralInfo get referralInfo => _referralInfo;
  List<NotificationItem> get notifications => _notifications;

  // Onboarding Navigators
  void navigateTo(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setLocality(Locality locality) {
    _currentLocality = locality;
    notifyListeners();
  }

  // Profile completion
  void completeProfile({required String name, required String email}) {
    _currentUser.name = name;
    _currentUser.email = email;
    _currentUser.avatar = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    _currentUser.profileCompletion = 100;
    notifyListeners();
  }

  // --- V2.0 FIRST-PICKUP BROADCAST FLOW ---
  CustomerJob broadcastJob({
    required String category,
    required String serviceName,
    required String description,
    required String date,
    required String time,
    required int budget,
    required List<String> mediaUrls,
  }) {
    final newJob = CustomerJob(
      id: 'KW-${10000 + (DateTime.now().millisecondsSinceEpoch % 90000)}',
      category: category,
      serviceName: serviceName,
      description: description,
      address: _currentLocality.fullAddress,
      date: date,
      time: time,
      status: 'BROADCASTING',
      visitFee: 199,
      estimatedAmount: budget,
      finalAmount: budget + 199,
      mediaUrls: mediaUrls,
    );

    _activeJob = newJob;
    _allJobs.insert(0, newJob);
    notifyListeners();

    // Simulate First Pickup atomic lock after 2 seconds
    Timer(const Duration(milliseconds: 2200), () {
      final worker = MockRepository.workers.first;
      _activeJob.status = 'WORKER_CONFIRMED';
      _activeJob.assignedWorker = worker;
      _activeJob.arrivalEta = '12 min';

      _messages.insert(
        0,
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: worker.name,
          text: 'Namaste! I have accepted your request for $serviceName. Preparing equipment.',
          time: 'Just now',
          isCustomer: false,
        ),
      );

      _notifications.insert(
        0,
        NotificationItem(
          id: 'n_${DateTime.now().millisecondsSinceEpoch}',
          title: '${worker.name} accepted your request!',
          subtitle: '${_activeJob.id} • Arriving in 12 min',
          time: 'Just now',
        ),
      );

      notifyListeners();
    });

    return newJob;
  }

  // Lifecycle updates
  void updateJobStatus(String newStatus) {
    _activeJob.status = newStatus;
    notifyListeners();
  }

  void approveInspectionEstimate() {
    _activeJob.isInspectionApproved = true;
    _activeJob.status = 'WORK_STARTED';
    notifyListeners();
  }

  void confirmCompletion() {
    _activeJob.isCompletedConfirmed = true;
    _activeJob.status = 'PAYMENT';
    notifyListeners();
  }

  void payBill(String method) {
    _activeJob.status = 'REVIEW';
    if (method == 'wallet' && _walletBalance >= _activeJob.finalAmount) {
      _walletBalance -= _activeJob.finalAmount;
      _walletTransactions.insert(
        0,
        WalletTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          type: 'DEBIT',
          amount: _activeJob.finalAmount.toDouble(),
          title: 'Service Payment (${_activeJob.id})',
          date: 'Just now',
          status: 'SUCCESS',
        ),
      );
    }
    notifyListeners();
  }

  void submitReview() {
    _activeJob.status = 'CLOSED';
    notifyListeners();
  }

  void addMessage(String text) {
    if (text.trim().isEmpty) return;
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: 'You',
        text: text.trim(),
        time: 'Just now',
        isCustomer: true,
      ),
    );
    notifyListeners();

    // Auto reply from assigned worker
    Timer(const Duration(milliseconds: 1400), () {
      _messages.add(
        ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          sender: _activeJob.assignedWorker?.name ?? 'Ramesh Kumar',
          text: 'Ji sir! Received. Reaching your doorstep on time.',
          time: 'Just now',
          isCustomer: false,
        ),
      );
      notifyListeners();
    });
  }

  // Wallet Topup
  void addWalletMoney(double amount) {
    _walletBalance += amount;
    _walletTransactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: 'CREDIT',
        amount: amount,
        title: 'Wallet Topup via UPI',
        date: 'Just now',
        status: 'SUCCESS',
      ),
    );
    notifyListeners();
  }

  // Redeem Referral Code
  bool redeemReferral(String code) {
    if (code.trim().toUpperCase() == 'FIRST100' || code.trim().length >= 4) {
      _walletBalance += 100.0;
      _walletTransactions.insert(
        0,
        WalletTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          type: 'CREDIT',
          amount: 100.0,
          title: 'Referral Bonus ($code)',
          date: 'Just now',
          status: 'SUCCESS',
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
