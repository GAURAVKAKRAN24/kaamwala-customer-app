@echo off
title KaamWala - Automated Security and API Test Matrix
echo Running KaamWala Automated Security and API Unit Tests...
python -m unittest backend/tests/test_security_and_api.py
pause
