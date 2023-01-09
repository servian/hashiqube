@echo off
python quiz-generator.py
cd generated-quizzes
start http://localhost:8000/
python -m http.server 8000
