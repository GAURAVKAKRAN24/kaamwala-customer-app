import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'mock_data.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final String time;
  final bool isCustomer;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    required this.isCustomer,
  });
}

class AppState extends ChangeNotifier {
  // Current Logged-in User (Real Authentication)
  AppUser? _currentUser = const AppUser(
    id: 'usr_849201',
    name: 'Aarav Sharma',
    email: 'aarav.sharma@gmail.com',
    phone: '+91 98765 43210',
    avatar: 'AS',
    authProvider: 'google',
    isVerified: true,
  );

  Locality _currentLocality = MockRepository.localities.first;
  String _language = 'en'; // 'en' or 'hi'
  CustomerJob _activeJob = MockRepository.createInitialJob();
  
  final List<CustomerJob> _pastJobs = [
    CustomerJob(
      id: 'KW-881920',
      category: 'Plumber',
      serviceName: 'Bathroom Tap Leakage Repair',
      description: 'Kitchen mixer tap washer worn out, dripping continuously.',
      address: 'Flat 402, Shipra Sun City, Indirapuram',
      date: '15 Sep 2026',
      time: '02:30 PM',
      status: 'CLOSED',
      visitFee: 149,
      estimatedAmount: 349,
      finalAmount: 349,
      selectedWorker: const Quote(
        id: 'q-past',
        workerId: 'w2',
        workerName: 'Rajesh Prajapati',
        workerRating: 4.85,
        workerJobs: 240,
        workerPhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        visitFee: 149,
        estimateMin: 299,
        estimateMax: 399,
        message: 'Job completed with 30-day guarantee',
        arrivalTime: 'Completed',
      ),
      quotes: [],
    ),
    CustomerJob(
      id: 'KW-774012',
      category: 'RO',
      serviceName: 'RO Purifier Complete Filter Change',
      description: 'Membrane kit change and sediment filter replacement.',
      address: 'Flat 402, Shipra Sun City, Indirapuram',
      date: '28 Aug 2026',
      time: '11:00 AM',
      status: 'CLOSED',
      visitFee: 149,
      estimatedAmount: 899,
      finalAmount: 899,
      quotes: [],
    ),
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'm1',
      sender: 'Manoj Kumar (Technician)',
      text: 'Namaste sir! I have accepted your AC service request. Reaching in 20 minutes.',
      time: '10:15 AM',
      isCustomer: false,
    ),
    ChatMessage(
      id: 'm2',
      sender: 'You',
      text: 'Great Manoj ji, please call the intercom when you reach the gate.',
      time: '10:17 AM',
      isCustomer: true,
    ),
    ChatMessage(
      id: 'm3',
      sender: 'Manoj Kumar (Technician)',
      text: 'Sure sir. I have genuine copper pipe spares and foam jet equipment with me.',
      time: '10:18 AM',
      isCustomer: false,
    ),
  ];

  // Getters
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  Locality get currentLocality => _currentLocality;
  String get language => _language;
  CustomerJob get activeJob => _activeJob;
  List<CustomerJob> get pastJobs => _pastJobs;
  List<ChatMessage> get messages => _messages;

  // --- Real Authentication Methods ---
  void loginWithGoogle() {
    _currentUser = const AppUser(
      id: 'usr_google_102',
      name: 'Aarav Sharma',
      email: 'aarav.sharma@gmail.com',
      phone: '+91 98765 43210',
      avatar: 'AS',
      authProvider: 'google',
      isVerified: true,
    );
    notifyListeners();
  }

  void loginWithPhone(String phone) {
    final cleanPhone = phone.startsWith('+91') ? phone : '+91 $phone';
    _currentUser = AppUser(
      id: 'usr_phone_${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: 'Verified Customer',
      email: 'customer@kaamwala.in',
      phone: cleanPhone,
      avatar: 'VC',
      authProvider: 'phone',
      isVerified: true,
    );
    notifyListeners();
  }

  void loginWithEmail(String email, String password) {
    final name = email.split('@').first;
    final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : 'KW';
    _currentUser = AppUser(
      id: 'usr_email_${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: name[0].toUpperCase() + name.substring(1),
      email: email,
      phone: '+91 98765 43210',
      avatar: initials,
      authProvider: 'email',
      isVerified: true,
    );
    notifyListeners();
  }

  void register({required String name, required String email, required String phone, required String password}) {
    final initials = name.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();
    _currentUser = AppUser(
      id: 'usr_reg_${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim().startsWith('+91') ? phone.trim() : '+91 ${phone.trim()}',
      avatar: initials.isEmpty ? 'KW' : initials,
      authProvider: 'email',
      isVerified: true,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // --- Location & Settings ---
  void setLocality(Locality locality) {
    _currentLocality = locality;
    notifyListeners();
  }

  void toggleLanguage() {
    _language = _language == 'en' ? 'hi' : 'en';
    notifyListeners();
  }

  // --- Real Job Operations ---
  void selectWorker(Quote quote) {
    _activeJob.selectedWorker = quote;
    _activeJob.status = 'WORKER_CONFIRMED';
    notifyListeners();
  }

  void cancelJob(String reason) {
    _activeJob.status = 'CLOSED';
    notifyListeners();
  }

  void addMessage(String text) {
    if (text.trim().isEmpty) return;
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: _currentUser?.name ?? 'You',
        text: text.trim(),
        time: 'Just now',
        isCustomer: true,
      ),
    );
    notifyListeners();

    // Auto worker reply
    Future.delayed(const Duration(milliseconds: 1200), () {
      _messages.add(
        ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          sender: _activeJob.selectedWorker?.workerName ?? 'KaamWala Support',
          text: 'Ji sir! Received your message. Will keep you updated.',
          time: 'Just now',
          isCustomer: false,
        ),
      );
      notifyListeners();
    });
  }

  void completePayment(String method) {
    _activeJob.status = 'REVIEW';
    notifyListeners();
  }

  void submitReview({
    required double rating,
    required double quality,
    required double behaviour,
    required double punctuality,
    required double priceFairness,
    required String comment,
  }) {
    _activeJob.status = 'CLOSED';
    _pastJobs.insert(0, _activeJob);
    notifyListeners();
  }

  void createNewJob({
    required String category,
    required String serviceName,
    required String description,
    required String date,
    required String time,
    required int price,
  }) {
    _activeJob = CustomerJob(
      id: 'KW-${(100000 + DateTime.now().millisecondsSinceEpoch % 900000)}',
      category: category,
      serviceName: serviceName,
      description: description,
      address: _currentLocality.fullAddress,
      date: date,
      time: time,
      status: 'QUOTATIONS_RECEIVED',
      visitFee: 149,
      estimatedAmount: price,
      finalAmount: price,
      quotes: MockRepository.createInitialJob().quotes,
    );
    notifyListeners();
  }
}
