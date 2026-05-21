# Aplikasi Katalog Buku dan Reading Tracker

# [cite_start] MobTeam #2 — Aplikasi Katalog Buku & Reading Tracker [cite: 38, 90]

[cite_start]Proyek ini merupakan aplikasi manajemen koleksi buku pribadi, pelacakan progres membaca, dan pemberian ulasan berbasis Mobile yang mendukung fungsionalitas penuh secara *offline* dengan sinkronisasi data ke *cloud server*[cite: 91, 92].

---

## [cite_start]👥 Anggota Tim 2 [cite: 86]
* [cite_start]**Marcelino Budi Prakasya**: bertanggung jawab pada pengembangan **Back-end API & Server Database**[cite: 44, 80].
* [cite_start]**Mikail Achmad**: bertanggung jawab pada pengembangan **Front-end Mobile Application & Local Database**[cite: 80].

> [cite_start]**Tenggat Pengumpulan:** 6 Juni 2026 [cite: 43, 103, 134]

---

## [cite_start]🛠️ Tech Stack Proyek [cite: 122, 123]

| Layer | Teknologi | Catatan |
| :--- | :--- | :--- |
| **Mobile Front-end** | Flutter (Dart SDK) | [cite_start]Manajemen UI/UX dan State Management [cite: 123] |
| **Local Database** | IsarDB | [cite_start]Penyimpanan model Buku, Progres, dan Review secara lokal (*offline*) [cite: 123] |
| **Back-end API** | Python (Flask Framework) | [cite_start]Penyedia REST API untuk manajemen data terpusat [cite: 44, 123] |
| **Server Database** | PostgreSQL | [cite_start]Penyimpanan data persisten di tingkat *cloud server* [cite: 123] |
| **HTTP Client** | Dio / Http (Package) | [cite_start]Media komunikasi data dari Flutter menuju Flask API [cite: 123] |

---

## 📂 Struktur Direktori Proyek (Monorepo)

[cite_start]Untuk menjaga modularitas, repositori ini menggunakan arsitektur monorepo yang memisahkan kode aplikasi mobile dengan server backend[cite: 82, 125]:

```text
Aplikasi Katalog Buku & Reading Tracker/
├── backend/                  # 🛠️ Workspace Marcel (Flask API)
│   ├── database/             # Skema dan migrasi DDL PostgreSQL
│   ├── app_flask.py          # Script utama server Flask
│   └── requirements.txt      # Dependencies Python
│
├── lib/                      # 💻 Workspace Miko (Flutter Application)
│   ├── models/               # Definisi skema objek IsarDB
│   ├── views/                # Komponen antarmuka (UI Pages & Widgets)
│   ├── services/             # Handler integrasi HTTP / API (Dio)
│   └── main.dart             # Entry point aplikasi Flutter
│
├── pubspec.yaml              # Konfigurasi package Flutter
└── README.md                 # Dokumentasi proyek
