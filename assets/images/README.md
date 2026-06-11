# Images

Place all image assets here. The app loads them by file name via
`AssetImageBox`. Missing files fall back to a placeholder icon, so you can add
images incrementally.

Expected file names (referenced by code / JSON — add as you get them):

- `logo.png` — faculty logo (splash screen)
- `faculty_map.png` — faculty overview map (home screen)
- `block_<x>_<floor>.png` — floor maps, e.g. `block_a_ground.png`, `block_b_level_1.png`
- room images — any name, referenced from the `"image"` field in `rooms.json`
- facility images — any name, referenced from the `"image"` field in `facilities.json`

Keep images small (ideally < 300 KB each) so the APK stays light.
