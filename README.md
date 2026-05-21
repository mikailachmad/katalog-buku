# Aplikasi Katalog Buku dan Reading Tracker

# MobTeam #2 — Aplikasi Katalog Buku & Reading Tracker

Proyek ini merupakan aplikasi manajemen koleksi buku pribadi, pelacakan progres membaca, dan pemberian ulasan berbasis Mobile yang mendukung fungsionalitas penuh secara *offline* dengan sinkronisasi data ke *cloud server*.

---

## Anggota Tim 2
* **Marcelino Budi Prakasya**: bertanggung jawab pada pengembangan **Back-end API & Server Database**.
* **Mikail Achmad**: bertanggung jawab pada pengembangan **Front-end Mobile Application & Local Database**.

---

## Tech Stack Proyek

| Layer | Teknologi | Catatan |
| :--- | :--- | :--- |
| **Mobile Front-end** | Flutter (Dart SDK) | Manajemen UI/UX dan State Management |
| **Local Database** | IsarDB | Penyimpanan model Buku, Progres, dan Review secara lokal (*offline*) |
| **Back-end API** | Python (Flask Framework) | Penyedia REST API untuk manajemen data terpusat |
| **Server Database** | PostgreSQL | Penyimpanan data persisten di tingkat *cloud server* |
| **HTTP Client** | Dio / Http (Package) | Media komunikasi data dari Flutter menuju Flask API |

---

## 📂 Struktur Direktori Proyek (Monorepo)

Untuk menjaga modularitas, repositori ini menggunakan arsitektur monorepo yang memisahkan kode aplikasi mobile dengan server backend:

```text
Aplikasi Katalog Buku & Reading Tracker/
├── backend/                  # Workspace Marcel (Flask API)
│   ├── database/             # Skema dan migrasi DDL PostgreSQL
│   ├── app_flask.py          # Script utama server Flask
│   └── requirements.txt      # Dependencies Python
│
├── lib/                      # Workspace Miko (Flutter Application)
│   ├── models/               # Definisi skema objek IsarDB
│   ├── views/                # Komponen antarmuka (UI Pages & Widgets)
│   ├── services/             # Handler integrasi HTTP / API (Dio)
│   └── main.dart             # Entry point aplikasi Flutter
│
├── pubspec.yaml              # Konfigurasi package Flutter
└── README.md                 # Dokumentasi proyek
