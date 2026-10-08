import uvicorn
import webbrowser
import threading
import time

def open_browser():
    time.sleep(1.5)
    print("\n Opening KaamWala Customer App & Web in your browser: http://127.0.0.1:8000/")
    webbrowser.open("http://127.0.0.1:8000/")

if __name__ == "__main__":
    print("=" * 65)
    print("  KaamWala — Trusted Local-Services Marketplace")
    print("  Customer Mobile App & Web + FastAPI + PostgreSQL")
    print("=" * 65)
    print("• Mobile Access (Same Wi-Fi):  http://10.28.238.74:9000/")
    print("• Local Computer:              http://127.0.0.1:9000/")
    print("• Swagger API Docs:            http://127.0.0.1:9000/docs")
    print("=" * 65)
    
    threading.Thread(target=open_browser, daemon=True).start()
    uvicorn.run("backend.app.main:app", host="0.0.0.0", port=9000)
