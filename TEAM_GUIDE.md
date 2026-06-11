# Team Guide — Who Does What

3 members, 6 weeks. The scaffold is already built and runs. Your job is to fill
it in with real FSKTM content, polish the UI, write the report, and present.

Read `PROJECT_GUIDE.md` first to understand the folders. Then find your section
below.

> **Rubric reminder:** Navigation 25% + UI/UX 20% + Information 20% = 65% of the
> grade. Get those solid before chasing bonus features.

---

## Shared rules (everyone)

1. **One source of style.** Always take colours from `Theme.of(context)` /
   `ColorScheme`. Never hard-code colours in a screen — UI consistency is 20%.
2. **Content goes in JSON, not Dart.** Add rooms/facilities/tips by editing
   files in `assets/data/`. Only change Dart when adding/altering behaviour.
3. **Run `flutter analyze` before you push.** It must say "No issues found!".
4. **Comment your code.** The rubric grades code quality and the brief requires
   commented code.
5. **Agree changes to shared files** (`main.dart`, `models/`, `app_data.dart`,
   `theme/`) in the group chat before editing, to avoid conflicts.

### Git workflow (if using GitHub — do NOT copy projects from GitHub, that's banned)
- `main` branch always runs.
- Each member works on a branch: `git checkout -b memberA-navigation`.
- Small, frequent commits with clear messages.
- Pull `main` before starting each day; open a pull request to merge.

---

## Member A — Navigation & Core (owns ~25% + app skeleton)

**You own the journey through the app: splash → home → block → floor → room.**

Files you own:
- `lib/main.dart` (routes, theme wiring)
- `lib/screens/splash_screen.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/block_screen.dart`
- `lib/screens/floor_screen.dart`
- `lib/widgets/room_card.dart`

Tasks:
1. Put the **real group info** into `splash_screen.dart` (names, course,
   semester, lecturer) — see the marked edit block.
2. Make sure navigation is **smooth and complete** end to end — every block,
   every floor, every room opens with no dead ends or errors. This is your
   biggest graded item.
3. Polish the **home screen** layout: block buttons, search bar, menu tiles,
   and the faculty map image.
4. Wire the floor map image naming convention with Member C
   (`block_a_ground.png`, etc.).
5. Help Member C verify the **dark mode** toggle looks right on every screen.

Demo responsibility: explain the **navigation flow** in the presentation.

---

## Member B — Information & Data (owns ~20% + code quality)

**You own all the content and the data layer that feeds every screen.**

Files you own:
- `assets/data/rooms.json`
- `assets/data/facilities.json`
- `lib/models/` (room, facility, green_tip)
- `lib/data/app_data.dart`
- `lib/screens/room_detail_screen.dart`
- `lib/screens/facility_screen.dart`

Tasks:
1. Replace the placeholder JSON with **real FSKTM data** for Blocks A, B and C —
   rooms, labs, lecturer rooms, meeting/discussion rooms, plus facilities
   (surau, pantry, parking, recycling corner, etc.). Use the official room list:
   http://csitapps.upm.edu.my/xry/day.php?day=14&month=05&year=2026
2. Keep `floor` and `block` values **consistent** (always `"Ground"`,
   `"Level 1"`, block `"A"`/`"B"`/`"C"`) — the navigation depends on it.
3. Make sure each **room detail** and **facility** page shows complete, tidy
   information (code, type, location, description, image).
4. Keep the data layer clean and well-commented (`app_data.dart`) — you're the
   main owner of the code-quality mark.

Demo responsibility: explain **data handling** (local JSON, models, loader).

---

## Member C — Search, Green, UI Polish & Docs (owns ~10% + 5% + UI/Doc/Present)

**You own search, the green module, visual consistency, and the deliverables.**

Files you own:
- `lib/screens/search_screen.dart`
- `lib/screens/green_screen.dart`
- `assets/data/green_tips.json`
- `lib/theme/app_theme.dart` + `lib/theme/theme_provider.dart`
- `assets/images/` (collecting logo, maps, photos)
- The **report** and **presentation slides**

Tasks:
1. Make **search accurate and functional** — searching room names, lab names
   and facility names must all work. Test edge cases (empty, no match).
2. Build out the **green awareness** content in `green_tips.json` and write a
   short paragraph for the report on how the app supports UPM campus
   sustainability (paperless navigation is the core idea).
3. Own **UI/UX consistency**: review every screen for spacing, fonts, colours;
   finish the **dark mode** bonus and confirm it on all screens.
4. Collect images into `assets/images/` (logo, faculty map, floor maps, a few
   room/facility photos) — coordinate names with Member A & B.
5. Lead the **project report** (intro, objectives, problem statement, app
   structure, UI screenshots, features, green integration, challenges,
   conclusion) and the **10–15 min presentation**.

Demo responsibility: explain the **green technology element** and **UI design**.

---

## 6-week timeline

| Week | Focus | A | B | C |
|---|---|---|---|---|
| 1 | Setup & agree schema | Real splash info, study routes | Design real JSON + models | Theme + image list |
| 2 | Core navigation works | Block→Floor→Room solid | Room/facility detail pages | Search skeleton |
| 3 | Modules complete | Home polish | Facilities + full data | Search functional |
| 4 | Green + polish | Fix flows | Fill all blocks' data | Green module + dark mode |
| 5 | Testing + bonus | Device testing | Verify data accuracy | UI screenshots, bonus features |
| 6 | Deliver | Help build APK | Help report | Report + slides + rehearse |

## Final deliverables (all members)
- [ ] Flutter source code (clean structure, commented)
- [ ] Installable APK (`flutter build apk --release`)
- [ ] Project report with UI screenshots
- [ ] 10–15 minute presentation
