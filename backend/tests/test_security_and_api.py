import unittest
from fastapi.testclient import TestClient
from backend.app.main import app
from backend.app.core.security import create_access_token

client = TestClient(app)

class TestKaamWalaSecurityAndAPI(unittest.TestCase):
    def setUp(self):
        # Generate token for customer 1
        self.cust1_token = create_access_token(data={"sub": "usr-cust-001", "role": "CUSTOMER"})
        self.cust1_headers = {"Authorization": f"Bearer {self.cust1_token}"}
        
        # Token for legitimate worker or second user who is not customer 1
        # Worker usr-wrk-003 is not assigned to KW-904128
        self.attacker_token = create_access_token(data={"sub": "usr-wrk-003", "role": "CUSTOMER"})
        self.attacker_headers = {"Authorization": f"Bearer {self.attacker_token}"}

    def test_health_check(self):
        res = client.get("/health")
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json()["status"], "healthy")

    def test_security_headers_present(self):
        res = client.get("/health")
        self.assertEqual(res.headers.get("x-content-type-options"), "nosniff")
        self.assertEqual(res.headers.get("x-frame-options"), "SAMEORIGIN")

    def test_categories_api(self):
        res = client.get("/api/v1/services/categories")
        self.assertEqual(res.status_code, 200)
        categories = res.json()
        self.assertGreaterEqual(len(categories), 8)
        self.assertTrue(any(c["id"] == "AC" for c in categories))
        self.assertTrue(any(c["id"] == "Electrician" for c in categories))

    def test_workers_discovery_ranking(self):
        res = client.get("/api/v1/workers?category=AC")
        self.assertEqual(res.status_code, 200)
        workers = res.json()
        self.assertTrue(len(workers) >= 1)
        # Check verified badge presence
        self.assertTrue(workers[0]["identity_verified"])

    def test_job_access_authorized_owner(self):
        # Customer 1 accessing own job KW-904128
        res = client.get("/api/v1/jobs/KW-904128", headers=self.cust1_headers)
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json()["id"], "KW-904128")

    def test_idor_bola_protection(self):
        """Security spec #26: Customer requests another customer's job -> 403 Forbidden"""
        res = client.get("/api/v1/jobs/KW-904128", headers=self.attacker_headers)
        # Expect 403 Forbidden
        self.assertEqual(res.status_code, 403)
        self.assertIn("Access Denied", res.json()["detail"])

    def test_invalid_jwt_token(self):
        """Security spec #26: Invalid JWT -> 401"""
        res = client.get("/api/v1/jobs/KW-904128", headers={"Authorization": "Bearer invalid_tampered_token_xyz"})
        self.assertEqual(res.status_code, 401)

    def test_missing_jwt_token(self):
        res = client.get("/api/v1/jobs/KW-904128")
        self.assertEqual(res.status_code, 401)

    def test_server_authoritative_payment_calculation(self):
        """Security spec #13: Server-side recalculation of bill breakdown"""
        res = client.post(
            "/api/v1/payments/calculate-breakdown?job_id=KW-904128&discount_code=FIRST100",
            headers=self.cust1_headers
        )
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertEqual(data["discount_amount"], 100.0)
        self.assertGreater(data["final_total"], 0)
        self.assertEqual(data["platform_fee"], 19.0)

    def test_otp_request_and_verify_flow(self):
        """Test OTP flow with rate limits and hash validation"""
        phone = "9988776655"
        req_res = client.post("/api/v1/auth/request-otp", json={"phone": phone})
        self.assertEqual(req_res.status_code, 200)
        demo_otp = req_res.json()["demo_otp"]
        
        # Verify with wrong OTP
        wrong_res = client.post("/api/v1/auth/verify-otp", json={"phone": phone, "otp": "000000"})
        self.assertEqual(wrong_res.status_code, 400)
        
        # Verify with correct OTP
        ver_res = client.post("/api/v1/auth/verify-otp", json={"phone": phone, "otp": demo_otp})
        self.assertEqual(ver_res.status_code, 200)
        self.assertIn("access_token", ver_res.json())

if __name__ == "__main__":
    unittest.main()
