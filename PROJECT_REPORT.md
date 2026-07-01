# FSKTM Navigation & Green Information App
### Project Report

**Course:** SSE3401 Mobile Application Development
**Semester:** Semester 2, 2025/2026
**Lecturer:** Dr. Sufri Muhammad
**Platform:** Flutter (Android)

**Group Members:**

| No. | Name | Matric No. |
|-----|------|------------|
| 1 | Fadhie Raihan Malano Zen | [matric no.] |
| 2 | Zenitho Ramadhan | [matric no.] |
| 3 | Li Yanxi | [matric no.] |
| 4 | [member name] | [matric no.] |
| 5 | [member name] | [matric no.] |

> Fill in the matric numbers and the remaining member name before submission. The same details appear on the app's splash screen in `lib/screens/splash_screen.dart`.

---

## Table of Contents

1. Introduction
2. Objectives
3. Problem Statement
4. Application Structure
5. Features Implemented
6. Green Technology Integration
7. UI Screenshots
8. Challenges
9. Conclusion

---

## 1. Introduction

This project is a mobile application for navigating the Faculty of Computer Science and Information Technology (FSKTM) at Universiti Putra Malaysia. It covers Block A, Block B, and Block C, and it works entirely offline using local data stored inside the app.

The app helps a student or visitor find a room, read information about a lab or office, look up faculty facilities such as the surau or cafeteria, and get simple written directions between two points. It also includes a green awareness section that supports UPM's campus sustainability effort by encouraging paperless navigation and everyday habits that save resources.

We built the app with Flutter and targeted Android, following the course focus on Flutter fundamentals, mobile UI design, navigation, and local data handling. There is no backend server. All room, facility, and sustainability data is read from JSON files bundled with the app.

## 2. Objectives

The project set out to do the following:

- Let users navigate between the three faculty blocks and their floors.
- Show room and laboratory information, including code, type, location, and a short description.
- List faculty facilities with their location and description.
- Provide a search function that works across room codes, English names, and Malay names.
- Support UPM's green campus initiative through a dedicated sustainability feature.
- Keep the interface clean and responsive so it works on both a tablet and a phone.

## 3. Problem Statement

New students, visitors, and even staff often have trouble finding rooms inside FSKTM. The three blocks each have several floors, and room codes such as A1.17 or B2.04 are not obvious to someone who does not already know the building. Printed directory boards exist at the stairwells, but they only help a person who is already standing in front of them, and they cannot be searched.

There is also the matter of paper. Printed maps and directories get outdated, and reprinting them wastes resources. A phone app removes that cost. It can be updated once and used by everyone, and it can carry extra information that a wall board has no room for, such as photos and descriptions of each room.

The app addresses both problems. It puts the whole faculty directory in one searchable place, and it doubles as a small sustainability tool by replacing printed material and reminding users of simple green habits.

## 4. Application Structure

The project follows a standard Flutter layout. Source code sits under `lib/`, and the data and images are under `assets/`.

```
lib/
  main.dart                 App entry point and theme setup
  data/
    app_data.dart           Loads and searches the JSON data
    building_map.dart       Coordinate model + directions engine
    floor_plans.dart        2D floor-plan artwork data
    route_guide.dart        Bridges rooms to the directions engine
  models/
    room.dart               Room data model
    facility.dart           Facility data model
    green_tip.dart          Green tip data model
  screens/
    splash_screen.dart      Logo, title, group details
    home_screen.dart        Search, block tiles, facilities, green banner
    block_screen.dart       Floor selector, floor map, room list
    room_detail_screen.dart Room photo, bilingual name, description
    facility_screen.dart    Facility list
    search_screen.dart      Live search results
    route_screen.dart       Start/destination picker and directions
    green_screen.dart       Sustainability tips
  widgets/
    floor_map.dart          Interactive 2D floor-plan renderer
    room_card.dart          Room list tile
    asset_image_box.dart    Image loader with a fallback placeholder
assets/
  data/                     rooms.json, facilities.json, green_tips.json
  images/                   Room and facility photos
```

The app uses the `provider` package to manage the light and dark theme, and it reads its content from three JSON files: `rooms.json` (67 rooms across Blocks A, B, and C), `facilities.json` (7 facilities), and `green_tips.json` (5 sustainability tips).

**Data handling.** On startup, `AppData` reads the three JSON files through Flutter's `rootBundle` and parses them into `Room`, `Facility`, and `GreenTip` objects. Every screen reads from this single loaded copy, so there is no repeated file access while the app runs. Each room stores a code, a Malay name, an English name, a type, a block, a floor, an image filename, and a description.

**Navigation.** The app uses Flutter's `Navigator` with named routes for the main screens and direct route pushes when a screen needs to carry data, for example opening a room's detail page or opening directions with the destination already filled in.

## 5. Features Implemented

**Splash screen.** Shows the faculty logo, the app title, and the group and course details. It loads the local data in the background before moving on to the home screen.

**Home screen.** The landing page has a greeting, a search bar, a "Get directions" button, tiles for each block, quick chips for facilities, and a banner into the green section. A button in the corner toggles dark mode. Content is width-capped and centered so it does not stretch awkwardly on a wide tablet.

**Block navigation and floor information.** Choosing a block opens a floor selector. Each floor shows a 2D map drawn in the same colour scheme as the physical directory boards (green for ground, orange for level one, blue for level two), followed by a list of the rooms on that floor. Tapping a room on the map opens a small sheet with the room's English name on top, its Malay name below, and buttons for full details or directions.

**Room and lab details.** Each room page shows a photo, the English and Malay names, the room code and type, its block and floor, and a description written for that room. From here the user can open turn-by-turn directions to the room or jump to its floor map.

**Facilities information.** A dedicated screen lists faculty facilities such as the two suraus, the cafeteria, the pantry, the recycling corner, the parking area, and the open-access computer lab, each with a location, a description, and an icon or photo.

**Search.** The search screen updates results as the user types and matches against room codes, English names, and Malay names, so a user can find a room whether they know it as "Software Engineering Lab", "Makmal Kejuruteraan Perisian", or "B0.10".

**Directions.** The directions screen lets the user pick a start and a destination, then generates written step-by-step instructions. The routing engine models each block as a central corridor with rooms along the walls, and it works out left and right based on the direction the user is walking. Blocks connect on the ground floor through the cafeteria, so a cross-block route goes down to the ground floor and back up.

**Green awareness.** A sustainability screen presents tips on going paperless, recycling correctly, saving electricity and water, and walking between nearby blocks. This is described in the next section.

**Bonus features.** The app includes three of the optional bonus items from the brief: a dark mode, an interactive floor map, and a directions system that goes beyond the basic requirement of showing a static map.

## 6. Green Technology Integration

The app supports UPM's campus green sustainability effort in two ways.

The first is the app itself. By putting the faculty directory and maps on a phone, it removes the need for printed maps and directory sheets. Nothing has to be reprinted when a room changes use, and no paper is handed out to new students. This is the paperless navigation idea from the brief, and it is built into how the whole app works rather than being a single screen.

The second is the green awareness screen. It lists five practical tips drawn from `green_tips.json`:

- Go paperless by using the app instead of printed maps.
- Recycle paper, plastic, and aluminium at the recycling corners in each block.
- Save electricity by switching off lights, fans, and projectors when leaving a room.
- Save water by reporting leaking taps and closing them tightly.
- Walk between Blocks A, B, and C instead of driving short distances.

Together these cover paperless practice, recycling, energy and water saving, and green transport, which are the sustainability themes suggested in the project brief.

## 7. UI Screenshots

> Insert screenshots taken from the tablet here. Suggested set:
>
> 1. Splash screen with group details
> 2. Home screen (light mode)
> 3. Home screen (dark mode)
> 4. Block A floor map (any floor)
> 5. Room detail page with a photo
> 6. Search screen with results
> 7. Directions screen with generated steps
> 8. Green awareness screen
>
> To capture on the tablet: open each screen, then take a screenshot (usually the power and volume-down buttons together), and paste the images into this section.

## 8. Challenges

**Drawing accurate floor maps.** The hardest part was turning the printed directory boards into a 2D map inside the app. Each room had to be placed by hand using coordinates, and the layout had to match the real building, including which rooms are merged, where the stairs and toilets sit, and how the corridor runs. We rebuilt the maps a few times after checking them against photos of the boards.

**Getting directions right.** Written directions need to know which side of the corridor a room is on. Instead of storing "left" or "right" for each room, which would be wrong when walking the other way, we stored each room's position along the corridor and worked out left and right from the walking direction. This took some thought but made the directions consistent in both directions.

**Bilingual display.** The faculty uses Malay names on its signs, but the app leads with English for a wider audience. We had to make sure the English name shows first everywhere, with the Malay name kept for display and for search, without breaking the layout on smaller rooms.

**Responsive layout.** The app is used on a tablet but should also work on a phone. We used percentage-based sizing for the floor maps and width-capped the content so it scales down without breaking.

**Collecting room photos.** Photos were taken from door plaques and rooms around the faculty and added over time. As of this report, 39 of the 67 rooms have photos, and the rest fall back to a neutral placeholder icon so the app still looks complete.

## 9. Conclusion

The app meets the goals set for the project. It lets users navigate the three FSKTM blocks and their floors, shows room and facility information, searches across codes and both languages, and includes a sustainability feature that supports UPM's green campus effort. It runs offline on local data, keeps a clean and responsive interface, and adds a few bonus features on top of the core requirements.

There is room to grow. More room photos can be added, Block C can get its own floor map to match Blocks A and B, and the walking directions can be checked against real routes and adjusted where needed. The current version is complete enough to install, demonstrate, and use inside the faculty.
