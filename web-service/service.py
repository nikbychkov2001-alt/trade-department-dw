import os
from flask import Flask, jsonify, request

app = Flask(__name__)

CATALOG = [
    {"title": "Каркассон", "min_players": 2, "max_players": 5, "duration_minutes": 45, "genre": "Стратегия"},
    {"title": "Колонизаторы (Catan)", "min_players": 3, "max_players": 4, "duration_minutes": 90, "genre": "Экономическая"},
    {"title": "Имаджинариум", "min_players": 4, "max_players": 7, "duration_minutes": 30, "genre": "Ассоциации"},
    {"title": "Дуэльная бродилка", "min_players": 2, "max_players": 2, "duration_minutes": 20, "genre": "Семейная"},
    {"title": "Большая пати-игра", "min_players": 6, "max_players": 12, "duration_minutes": 60, "genre": "Для компании"},
    {"title": "Глобальная стратегия", "min_players": 1, "max_players": 6, "duration_minutes": 180, "genre": "Хардкор"}
]

@app.route('/search', methods=['GET'])
def search_games():
    players = request.args.get('players', type=int)
    max_time = request.args.get('time', type=int)
    
    results = CATALOG
    if players is not None:
        results = [g for g in results if g['min_players'] <= players <= g['max_players']]
    if max_time is not None:
        results = [g for g in results if g['duration_minutes'] <= max_time]
        
    return jsonify({
        "query": {"players": players, "max_time": max_time},
        "matches": results,
        "count": len(results)
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    app.run(host='0.0.0.0', port=port)
