import os
import requests
import psycopg2
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Board Games Club API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("POSTGRES_DB", "gamesdb")
DB_USER = os.getenv("POSTGRES_USER", "postgres")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "postgres")
WEB_SERVICE_URL = os.getenv("WEB_SERVICE_URL", "http://web-service:5001")

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

@app.get("/api/games")
def get_games():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT id, title, min_players, max_players, duration_minutes, genre, added_at FROM board_games ORDER BY id;")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        
        games = []
        for row in rows:
            games.append({
                "id": row[0],
                "title": row[1],
                "min_players": row[2],
                "max_players": row[3],
                "duration_minutes": row[4],
                "genre": row[5],
                "added_at": row[6].strftime("%Y-%m-%d %H:%M:%S") if row[6] else None
            })
        return games
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/search")
def search_games(players: int = 4, time: int = 60):
    try:
        resp = requests.get(f"{WEB_SERVICE_URL}/search", params={"players": players, "time": time}, timeout=5)
        if resp.status_code != 200:
            raise HTTPException(status_code=502, detail="Web service error")
        return resp.json()
    except requests.RequestException as e:
        raise HTTPException(status_code=503, detail=f"Web service unreachable: {str(e)}")
