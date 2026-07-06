import os
import requests
from dotenv import load_dotenv

def test_supabase_rest():
    load_dotenv(dotenv_path="C:/Users/SUBHASH/Desktop/ayureze-doctor-app-8e6bd855b5e7644b11703f075bcac76d3d2989fc/.env")
    
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_ANON_KEY")
    
    if not url or not key:
        print("❌ Error: Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env")
        return
        
    print(f"Connecting to Supabase REST API at: {url}")
    
    headers = {
        "apikey": key,
        "Authorization": f"Bearer {key}",
        "Content-Type": "application/json"
    }
    
    try:
        # Perform a safe GET request to test authentication and connectivity
        response = requests.get(f"{url}/rest/v1/doctors?select=unique_id&limit=1", headers=headers)
        
        if response.status_code == 200:
            print("✅ SUCCESS: Successfully connected to Supabase REST API and authenticated!")
            print(f"Response: {response.json()}")
        else:
            print(f"❌ FAILED: Received status code {response.status_code}")
            print(f"Error: {response.text}")
            
    except Exception as e:
        print(f"❌ FAILED: Exception occurred - {e}")

if __name__ == "__main__":
    test_supabase_rest()
