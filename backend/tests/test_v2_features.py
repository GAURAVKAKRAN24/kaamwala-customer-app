import unittest
from fastapi.testclient import TestClient
from backend.app.main import app
from backend.app.core.security import create_access_token

client = TestClient(app)

class TestV2Features(unittest.TestCase):
    def setUp(self):
        self.token = create_access_token(data={"sub": "usr-cust-001", "role": "CUSTOMER"})
        self.headers = {"Authorization": f"Bearer {self.token}"}

    def test_wallet_balance(self):
        res = client.get("/api/v1/wallet/balance", headers=self.headers)
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertIn("balance", data)
        self.assertEqual(data["currency"], "INR")

    def test_wallet_referral(self):
        res = client.get("/api/v1/wallet/referral", headers=self.headers)
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertIn("referral_code", data)
        self.assertEqual(data["reward_per_referral"], 100.0)

    def test_geo_suggestions(self):
        res = client.get("/api/v1/geo/suggest?q=noida")
        self.assertEqual(res.status_code, 200)
        data = res.json()
        self.assertIn("results", data)
        self.assertTrue(len(data["results"]) > 0)
        self.assertTrue(any("Noida" in item["city"] for item in data["results"]))

    def test_first_pickup_broadcast_and_accept(self):
        # 1. Broadcast job
        job_data = {
            "category": "AC",
            "service_name": "AC Deep Jet Cleaning",
            "description": "AC not cooling, coil wash needed",
            "address_snapshot": "Sector 18, Noida • 201301",
            "preferred_date": "Today",
            "preferred_time": "02:00 PM - 04:00 PM",
            "budget_range": "₹1200 - ₹1800",
            "media_urls": ["ac_filter.jpg"]
        }
        res_broadcast = client.post("/api/v1/jobs/broadcast", json=job_data, headers=self.headers)
        self.assertEqual(res_broadcast.status_code, 200)
        job = res_broadcast.json()
        job_id = job["job_id"]
        self.assertEqual(job["status"], "BROADCASTING")

        # 2. Worker accepts (first-pickup atomic lock)
        res_accept = client.post(f"/api/v1/jobs/{job_id}/accept-worker?worker_id=usr-wrk-001")
        self.assertEqual(res_accept.status_code, 200)
        accepted_job = res_accept.json()
        self.assertEqual(accepted_job["status"], "WORKER_CONFIRMED")

        # 3. Customer approves inspection estimate
        res_approve = client.post(
            f"/api/v1/jobs/{job_id}/approve-estimate",
            headers=self.headers
        )
        self.assertEqual(res_approve.status_code, 200)
        self.assertEqual(res_approve.json()["status"], "WORK_STARTED")

        # 4. Confirm completion
        res_done = client.post(f"/api/v1/jobs/{job_id}/confirm-completion?confirmed=true", headers=self.headers)
        self.assertEqual(res_done.status_code, 200)
        self.assertEqual(res_done.json()["status"], "PAYMENT")

if __name__ == "__main__":
    unittest.main()
