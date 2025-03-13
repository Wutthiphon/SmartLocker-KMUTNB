# SmartLocker (KMUTNB Project)

ใน Repository จะรวมทั้ง ESP32 Code Flutter และ Node ไว้ด้วยกัน โดยจะอยู่ใน Folder ดังนี้
- Iot : Code ของ ESP32
- Frontend_Flutter : Code ของ Flutter
- Backend_Node : Code ของ Node
## Installation

Flutter

```bash
  เข้า Folder Frontend_Flutter
  flutter pub get
  เปลี่ยนไฟล์ .env.example เป็น .env แล้วตั้งค่าให้เรียบร้อย
  flutter run
```

Backend

```bash
  ติดตั้ง Database โดยใช้ไฟล์ database.sql

  เข้า Folder Backend_Node
  npm install
  เปลี่ยนไฟล์ .env.example เป็น .env แล้วตั้งค่าให้เรียบร้อย
  node src/server.ts หรือ nodemon src/server.ts
```
    
## แนะนำการใช้งาน

Youtube https://youtube.com/shorts/Kuzy1tAbNSs?feature=share

