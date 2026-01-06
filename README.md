deploy.sh için :
ci/ → otomasyon & pipeline dosyaları

terraform/ → infra kodu

Script path-safe

GitHub Actions’ta birebir çalışır

Local’de de aynı

Bu yapı:

Local ≈ CI/CD = sürpriz yok
-----------------
ADESSO+dyildiz@C9BXVL3 MINGW64 /c/Otto/GCP_DEMO/GCP_DEMO
Git Bash

MSYS2 tabanlı

Linux davranışını taklit eder

Git Bash:

./script.sh görünce

Shebang (#!/bin/bash) varsa

Script’i bash ile çalıştırır

Yani aslında bu oldu:

bash ci/deploy.sh dev plan


Bu yüzden:

Executable bit olmasa bile çalıştı 

Cloud Scheduler (her 1 saat)
|
v
HTTP request
|
v
Cloud Run
|
v
Kotlin app (senin kod)
|
v
GCS bucket
