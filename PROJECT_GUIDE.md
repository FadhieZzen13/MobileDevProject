# FSKTM Navigation & Green Information App — Project Guide

A Flutter (Android) app for navigating FSKTM Blocks A, B and C, viewing
room/lab/facility information, searching, and promoting green-campus
sustainability. **No backend** — all content is loaded from local JSON files.

This guide explains how the project is organised so any team member can find
their way around and run it.

---

## 1. Running the app

```bash
flutter pub get          # install dependencies (run once, or after pubspec changes)
flutter run              # run on a connected Android device / emulator
flutter analyze          # static analysis — should report "No issues found!"
flutter test             # run the smoke test
flutter build apk        # build the installable APK (final deliverable)
```

The release APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

---

## 2. Directory structure

```
MobileProject/
├── lib/
│   ├── main.dart                  # App entry: routes, theme, provider setup
│   ├── models/                    # Plain Dart data classes (the "shape" of the JSON)
│   │   ├── room.dart
│   │   ├── facility.dart
│   │   └── green_tip.dart
│   ├── data/
│   │   └── app_data.dart          # Loads JSON once + query helpers (blocks, floors, search)
│   ├── theme/
│   │   ├── app_theme.dart         # Central colours / light + dark ThemeData
│   │   └── theme_provider.dart    # Dark-mode toggle state (provider)
│   ├── screens/                   # One file per screen (see requirement map below)
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── block_screen.dart
│   │   ├── floor_screen.dart
│   │   ├── room_detail_screen.dart
│   │   ├── facility_screen.dart
│   │   ├── search_screen.dart
│   │   └── green_screen.dart
│   └── widgets/                   # Reusable UI pieces
│       ├── asset_image_box.dart   # Image with automatic placeholder fallback
│       └── room_card.dart
├── assets/
│   ├── data/                      # ALL CONTENT lives here — edit these, not the code
│   │   ├── rooms.json
│   │   ├── facilities.json
│   │   └── green_tips.json
│   └── images/                    # logo, maps, room/facility photos (see images/README.md)
├── test/
│   └── widget_test.dart           # Smoke test
├── PROJECT_GUIDE.md               # This file
└── TEAM_GUIDE.md                  # Per-member tasks, workflow and timeline
```

---

## 3. How navigation flows

```
SplashScreen ──(2s, after loading JSON)──▶ HomeScreen
HomeScreen ─▶ BlockScreen(block) ─▶ FloorScreen(block, floor) ─▶ RoomDetailScreen(room)
HomeScreen ─▶ FacilityScreen
HomeScreen ─▶ SearchScreen ─▶ RoomDetailScreen(room)
HomeScreen ─▶ GreenScreen
```

- Screens **without arguments** (Home, Facilities, Search, Green) use **named
  routes**, registered in `main.dart`. Navigate with
  `Navigator.pushNamed(context, HomeScreen.route)`.
- Screens that **need typed arguments** (Block, Floor, Room) are pushed with
  `MaterialPageRoute`, e.g.
  `Navigator.push(context, MaterialPageRoute(builder: (_) => BlockScreen(block: 'A')))`.

---

## 4. The data layer (most important to understand)

All content comes from three JSON files in `assets/data/`. To add or change a
room, facility or tip you edit JSON — **you do not touch Dart code**.

`AppData` (in `lib/data/app_data.dart`) loads these files once on the splash
screen and offers helpers:

| Method | Returns |
|---|---|
| `AppData.instance.blocks` | `['A', 'B', 'C']` |
| `floorsForBlock('A')` | distinct floors that have rooms in Block A |
| `roomsForFloor('A', 'Ground')` | rooms on that floor |
| `search('lab')` | mixed list of matching `Room` + `Facility` |

### rooms.json — one object per room
```json
{
  "code": "Software Engineering Lab 1",
  "type": "Lab",
  "block": "A",
  "floor": "Ground",
  "image": "se_lab1.png",
  "description": "Software Engineering teaching lab."
}
```
- `block` must be `"A"`, `"B"` or `"C"`.
- `floor` text is matched exactly — keep it consistent (e.g. always `"Ground"`,
  `"Level 1"`). Floors are listed in the order they first appear.
- `image` is a file name inside `assets/images/`; leave `""` for none.
- Room names should follow the official UPM list:
  http://csitapps.upm.edu.my/xry/day.php?day=14&month=05&year=2026

### facilities.json — one object per facility
```json
{ "name": "Surau", "location": "Block A, Ground Floor",
  "description": "...", "image": "", "icon": "mosque" }
```
`icon` (used when there is no image) is one of:
`mosque`, `restaurant`, `local_parking`, `recycling`, `computer` (default: a
generic building icon).

### green_tips.json — one object per tip
```json
{ "title": "Save Electricity", "category": "Save Electricity",
  "description": "...", "icon": "electricity" }
```
`icon` is one of: `recycling`, `water`, `electricity`, `paperless`, `walk`.

---

## 5. Images

Drop image files into `assets/images/` (see `assets/images/README.md` for the
expected names). Missing images automatically render as a placeholder icon via
`AssetImageBox`, so the app always runs even before photos are added.

Expected names: `logo.png`, `faculty_map.png`, floor maps like
`block_a_ground.png` / `block_b_level_1.png`, plus any room/facility photos you
reference from the JSON.

---

## 6. Requirement → file map (for the report & grading)

| Brief requirement | Where it lives |
|---|---|
| #1 Splash screen | `lib/screens/splash_screen.dart` |
| #2 Home screen | `lib/screens/home_screen.dart` |
| #3 Block navigation | `lib/screens/block_screen.dart` |
| #4 Floor information | `lib/screens/floor_screen.dart` |
| #5 Room / lab details | `lib/screens/room_detail_screen.dart` |
| #6 Facilities information | `lib/screens/facility_screen.dart` |
| #7 Search function | `lib/screens/search_screen.dart` |
| #8 Green awareness | `lib/screens/green_screen.dart` |
| Dark mode (bonus) | `lib/theme/` + toggle in home app bar |

---

## 7. Before submission checklist

- [ ] Update group member names, course, semester, lecturer in
      `splash_screen.dart` (the `EDIT THESE BEFORE SUBMISSION` block).
- [ ] Replace placeholder JSON with real FSKTM rooms/facilities.
- [ ] Add `logo.png`, `faculty_map.png` and floor maps to `assets/images/`.
- [ ] `flutter analyze` reports no issues.
- [ ] Build the APK: `flutter build apk --release`.
- [ ] Take UI screenshots for the report.
