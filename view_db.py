"""
KaamWala Database Viewer Utility
Run: python view_db.py [optional_table_name]
Example:
    python view_db.py
    python view_db.py kw_users
    python view_db.py kw_jobs
    python view_db.py kw_worker_profiles
"""

import sys
import sqlite3
import os

# Ensure safe printing on Windows command line
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8')

DB_PATH = os.path.join(os.path.dirname(__file__), "kaamwala.db")

def print_separator(char="-", length=70):
    print(char * length)

def list_all_tables():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
    tables = [row[0] for row in cursor.fetchall()]
    
    print("\n" + "=" * 60)
    print(" [DATABASE] KAAMWALA LOCAL DATABASE (kaamwala.db)")
    print("=" * 60)
    print(f"{'TABLE NAME':<30} | {'TOTAL ROWS'}")
    print_separator()
    for table in tables:
        count = cursor.execute(f"SELECT count(*) FROM {table}").fetchone()[0]
        print(f"{table:<30} | {count} records")
    print_separator()
    print("\nTip: Run 'python view_db.py <table_name>' to view table data.")
    print("Example: python view_db.py kw_users")
    print("Example: python view_db.py kw_jobs\n")
    conn.close()

def view_table(table_name):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    try:
        cursor.execute(f"PRAGMA table_info({table_name})")
        columns = [col[1] for col in cursor.fetchall()]
        if not columns:
            print(f"[!] Table '{table_name}' does not exist.")
            conn.close()
            return

        cursor.execute(f"SELECT * FROM {table_name} LIMIT 20")
        rows = cursor.fetchall()

        print("\n" + "=" * 70)
        print(f" [TABLE] {table_name} (Showing top {len(rows)} records)")
        print("=" * 70)
        
        for idx, row in enumerate(rows, 1):
            print(f"--- Record #{idx} ---")
            for col, val in zip(columns, row):
                print(f"  {col:<24}: {val}")
            print()
        
    except Exception as e:
        print(f"[!] Error reading table: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    if not os.path.exists(DB_PATH):
        print(f"[!] Database file not found at {DB_PATH}")
        sys.exit(1)
        
    if len(sys.argv) > 1:
        view_table(sys.argv[1])
    else:
        list_all_tables()
