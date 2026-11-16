# Туристичний додаток (Flutter) — Лабораторна робота №6

Реалізовано роботу з `FutureBuilder`, `StreamBuilder`, `GET` та `POST` запитами до REST API, обробку помилок мережі та `RefreshIndicator`.

## Структура проєкту
- `lib/models/` — модель даних `TravelDestination` з парсингом JSON (`fromJson`)
- `lib/services/` — сервіс `ApiService` для HTTP-запитів (`getDestinations`, `createDestination`)
- `lib/screens/` — екран `TravelScreen` із поєднанням `FutureBuilder` та `StreamBuilder`
