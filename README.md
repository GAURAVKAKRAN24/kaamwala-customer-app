# KaamWala — Customer App & Web Platform 🛠️🇮🇳

> **Trusted Local-Services Marketplace Connecting Customers with Verified Professionals in India.**  
> Built strictly in compliance with the **KaamWala Product Requirements Document (PRD v1.0)** and **Technical Architecture & Security Specification (v1.0)**.

---

## 🌟 Executive Overview & Key Highlights

KaamWala is engineered to address the trust deficit in India's home and local services sector through **multi-factor worker verification**, **transparent quotation comparison**, **end-to-end 11-stage job lifecycle tracking**, **privacy-first communication (masked telephony)**, and **authoritative server-verified escrow payments with GST tax invoicing**.

### 📱 Dual-Mode Responsive Experience
- **Mobile Smartphone Mockup Mode**: Pixel-perfect native mobile app layout with status bar, dynamic notch, top identity headers, and bottom navigation bar (`Home`, `Jobs`, `Chat`, `Profile`).
- **Desktop Web Dashboard Mode**: 1-click toggle to transform the app into an expansive, modern desktop web dashboard.
- **Bilingual Localization (English & हिन्दी)**: Full 1-click instantaneous translation across all screens, buttons, categories, alerts, and statuses.

---

## 🏗️ Architecture & Technology Stack

| Layer | Technology | Key Responsibility |
|---|---|---|
| **Frontend App** | HTML5, Tailwind CSS, Modern ES6+, FontAwesome | Responsive Customer Web + Mobile App PWA with instant bilingual i18n & offline caching |
| **Backend REST API** | FastAPI + Python 3.14 | High-performance async REST API with versioning (`/api/v1`) & OpenAPI docs |
| **Database** | PostgreSQL (Neon) & SQLite Automatic Failover | Parameterized SQLAlchemy 2.0 ORM with `kw_` scoped models |
| **Security Layer** | PyJWT, Cryptography, Secrets, HMAC SHA-256 | Object-Level Authorization (Anti-BOLA/IDOR), rate limiting, cryptographic OTP |
| **Invoicing & Taxes** | Server-calculated GST (18%) + Escrow verification | Downloadable & printable official GST Tax Invoices |

---

## 🔒 Security Architecture & Specification Compliance

As mandated by the **Technical Architecture & Security Specification**:
1. **Object-Level Authorization (Anti-BOLA / Anti-IDOR)**:
   - Handled via `verify_job_access()`: Guarantees that users cannot view or modify another customer's job by changing IDs in URLs.
   - Tested & validated in the automated test suite.
2. **Cryptographic OTP Generation & Hash Verification**:
   - OTPs generated using Python's `secrets` module.
   - Plaintext OTPs are never stored; verified via constant-time HMAC/SHA-256 comparison to prevent timing attacks.
3. **Defense-in-Depth Rate Limiting**:
   - Sliding-window rate limiter with progressive lockouts on authentication, OTP requests, chat messaging, and quote interactions.
4. **Authoritative Server-Side Pricing (No Client-Side Price Tampering)**:
   - The final bill, visit fee, discounts (`FIRST100`), and GST (18%) are calculated authoritatively on the backend via `/api/v1/payments/calculate-breakdown`.
5. **OWASP Security Headers**:
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options: SAMEORIGIN`
   - `X-XSS-Protection: 1; mode=block`
   - `Referrer-Policy: strict-origin-when-cross-origin`
6. **Immutable Audit Logging**:
   - All critical actions (logins, job status changes, quote selections, payments) are logged to `kw_audit_logs`.

---

## 🔄 11-Stage Interactive Job Lifecycle

KaamWala implements the exact 11-stage state machine from the PRD:

```
[1. REQUESTED] 
       ↓
[2. QUOTATIONS_RECEIVED] 
       ↓
[3. WORKER_SELECTED] (Other quotes auto-expire)
       ↓
[4. WORKER_CONFIRMED]
       ↓
[5. ON_THE_WAY]
       ↓
[6. ARRIVED]
       ↓
[7. INSPECTION]
       ↓
[8. WORK_STARTED]
       ↓
[9. WORK_COMPLETED]
       ↓
[10. PAYMENT] (Server-verified UPI/Cards + GST Invoice)
       ↓
[11. REVIEW & CLOSED] (Verified Job badge + 4 sub-ratings)
```

> 💡 **Built-in Interactive Simulator**: On the Job Detail screen, a dedicated simulator toolbar lets testers advance through any lifecycle state with 1 click to test notifications, system chat messages, and UI updates!

---

## 🚀 Quick Start Guide

### 1. Launch with One Click (Windows)
Double-click `start.bat` or run:
```powershell
python run_app.py
```
This automatically starts the server and launches your browser at `http://127.0.0.1:8000/`.

### 2. Available URLs
- **Web App**: [http://127.0.0.1:8000/](http://127.0.0.1:8000/)
- **Interactive Swagger API Docs**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **Health Check**: [http://127.0.0.1:8000/health](http://127.0.0.1:8000/health)

### 3. Run Automated Security & API Tests
Double-click `run_tests.bat` or run:
```powershell
python -m unittest backend/tests/test_security_and_api.py
```
All 10 security test scenarios pass with `10/10 OK`.

---

## 📋 Comprehensive PRD Feature Mapping

| PRD Section | Feature | Implementation in KaamWala |
|---|---|---|
| **Section 3 & 4** | Navigation & Auth | Mobile bottom bar + Desktop Web header; Phone/OTP login with rate limits |
| **Section 5 & 6** | Home & Create Request | 9 categories, search suggestions, active job banner, 6-step service request posting |
| **Section 7 & 8** | Discovery & Profiles | Multi-factor ranking (not just stars), verified badges, worker stats, before/after photos |
| **Section 9** | Quotations | Side-by-side comparison, visit fee + estimate range, auto-expiration of competing quotes |
| **Section 10** | Job Tracking | Visual 11-stage stepper, live timestamps, interactive simulation controls |
| **Section 11** | Chat & Calling | In-app encrypted chat with system events + masked telephony bridge modal |
| **Section 12** | Payment & Invoicing | Server-authoritative bill breakdown, UPI/Cards/Netbanking, GST tax invoice generator |
| **Section 13** | Reviews & Ratings | 1-5 star rating + 4 sub-ratings (quality, behavior, punctuality, price), Verified Job badge |
| **Section 14 & 15** | Care Plans & Profile | KaamWala Care annual subscriptions, saved addresses with landmarks, repeat booking |
| **Section 16 & 17** | Notifications & Support | Push & in-app notification center, dispute help desk ticket system |
