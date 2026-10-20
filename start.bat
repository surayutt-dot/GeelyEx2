@echo off
chcp 65001 > nul
title Geely E2 EV Charging Tracker
echo ========================================================
echo   Geely E2 EV Charging Expense Tracker
echo ========================================================
echo.
echo กำลังเปิดเซิร์ฟเวอร์...
echo.
start "" http://localhost:3000
node server.js
pause
