// 2D floor-plan artwork, traced from the faculty directory boards.
//
// Each FloorArt is a list of cells in a viewBox coordinate space (vw x vh);
// the renderer scales it to the available width. Room cells carry a roomCode
// matching rooms.json so taps can open the room, plus a short English label.
// Floors are colour-coded like the boards: ground = green, level 1 = orange,
// level 2 = blue. Background cells (corridor, suite outline) are listed first
// so the renderer paints them behind the rooms.

enum CellType { room, toilet, stairs, corridor, service, kafeteria, suite, door }

class PlanCell {
  final String label; // short English name, or marker text
  final String? roomCode; // non-null = tappable room
  final double x, y, w, h;
  final CellType type;
  const PlanCell(this.label, this.x, this.y, this.w, this.h, this.type,
      {this.roomCode});
}

class FloorArt {
  final double vw, vh;
  final List<PlanCell> cells;
  const FloorArt(this.vw, this.vh, this.cells);
}

// Tappable room cell whose label is its short English name.
PlanCell _r(String code, String label, double x, double y, double w, double h) =>
    PlanCell(label, x, y, w, h, CellType.room, roomCode: code);

PlanCell _c(double x, double y, double w, double h) =>
    PlanCell('', x, y, w, h, CellType.corridor);

class FloorPlans {
  FloorPlans._();

  /// Look up the plan for a block + floor selection, or null if none.
  static FloorArt? of(String block, String floor) {
    final ground = floor.toLowerCase().contains('ground');
    final lvl2 = floor.contains('2');
    if (block == 'A') {
      if (ground) return _aGround;
      return lvl2 ? _a2 : _a1;
    }
    if (block == 'B') {
      if (ground) return _bGround;
      return lvl2 ? _b2 : _b1;
    }
    return null;
  }

  // ---- BLOCK A · GROUND (green) · entrance at bottom -----------------------
  static final _aGround = FloorArt(100, 106, [
    _c(44, 3, 14, 101),
    PlanCell('Bilik Rehat', 3, 3, 13, 11, CellType.service),
    PlanCell('Bilik Pump', 16, 3, 13, 11, CellType.service),
    PlanCell('Stor', 3, 15, 13, 11, CellType.service),
    PlanCell('Bilik PABX', 16, 15, 13, 11, CellType.service),
    PlanCell('Toilet', 30, 3, 14, 23, CellType.toilet),
    _r('A0.01', 'Postgraduate Lab 2', 60, 3, 18, 14),
    _r('A0.02', 'Master Lab', 79, 3, 18, 14),
    PlanCell('Stairs', 45, 5, 12, 20, CellType.stairs),
    _r('A0.04 & A0.05', 'Postgraduate Lab 1', 60, 22, 37, 16),
    _r('A0.06 & A0.07', 'Putra Future Classroom', 60, 41, 37, 16),
    _r('A0.14 & A0.15', 'Main Lecture Hall', 3, 32, 40, 42),
    _r('A0.09 & A0.10', "Chief Admin Office", 60, 60, 37, 12),
    _r('A0.09A', 'Asst. Admin Officer', 60, 76, 18, 16),
    _r('A0.10A', 'Administrative Officer', 79, 76, 18, 16),
    _r('A0.12', 'ICT Section', 3, 78, 13, 16),
    _r('A0.13', 'Chief ICT Room', 16, 78, 13, 16),
    _r('A0.11', 'Server Room', 29, 78, 14, 16),
    PlanCell('Stairs', 45, 76, 12, 15, CellType.stairs),
    PlanCell('Main entrance', 40, 98, 20, 6, CellType.door),
  ]);

  // ---- BLOCK A · LEVEL 1 (orange) · horizontal corridor --------------------
  static final _a1 = FloorArt(100, 98, [
    PlanCell('Dean & Deputies', 84, 3, 13, 75, CellType.suite),
    _r('A1.30', 'Male Prayer Room', 3, 3, 23, 15),
    PlanCell('Toilet', 28, 3, 17, 16, CellType.toilet),
    PlanCell('Stairs', 47, 3, 11, 16, CellType.stairs),
    _r('A1.29', 'Female Prayer Room', 3, 33, 23, 16),
    _r('A1.27', 'File Store', 3, 51, 23, 16),
    _r('A1.24', 'Information Security', 3, 80, 23, 16),
    _r('A1.19', 'Stationery Store', 28, 33, 17, 16),
    _r('A1.17', 'Seminar Room', 28, 51, 17, 25),
    _r('A1.16', 'Quality Assurance', 28, 80, 17, 16),
    _r('A1.15', 'Deputy Dean (Graduate)', 60, 3, 12, 15),
    _r('A1.14', "Dean's Office", 73, 3, 11, 15),
    PlanCell('Toilet', 73, 19, 11, 7, CellType.toilet),
    _r('A1.12', 'Admin Officer', 60, 21, 12, 12),
    _r('A1.13', 'Admin Officer', 73, 28, 11, 10),
    _r('A1.09', 'Academic / Graduate / Research Units', 60, 40, 23, 31),
    _r('A1.01', "Dean's Office", 84, 3, 13, 12),
    _r('A1.02', 'Deputy Dean (R&I)', 84, 16, 13, 11),
    _r('A1.03', 'File Room', 84, 28, 13, 11),
    _r('A1.04', "Visitor's Room", 84, 40, 13, 11),
    _r('A1.05', 'Deputy Dean (Academic)', 84, 52, 13, 11),
    _r('A1.06', 'Head, Graduate Studies', 84, 64, 13, 11),
    PlanCell('Stairs', 47, 80, 11, 16, CellType.stairs),
    _r('A1.08', 'Meeting Room A', 60, 80, 17, 16),
    _r('A1.07', 'Lounge', 78, 80, 19, 16),
  ]);

  // ---- BLOCK A · LEVEL 2 (blue) · horizontal corridor ----------------------
  static final _a2 = FloorArt(100, 90, [
    _r('A2.33', 'Software Engineering', 3, 3, 23, 16),
    PlanCell('Toilet', 28, 3, 17, 16, CellType.toilet),
    PlanCell('Stairs', 47, 3, 11, 16, CellType.stairs),
    _r('A2.32', 'Lecture Room 3', 3, 36, 23, 28),
    _r('A2.28', 'Graphics, Vision & Visualization', 3, 72, 23, 15),
    _r('A2.26', 'Applied Informatics Lab', 28, 30, 17, 18),
    _r('A2.25', 'Human-Computer Interaction', 28, 50, 17, 20),
    _r('A2.24', 'Digital Info Retrieval', 28, 72, 17, 15),
    _r('A2.23', 'Intelligent Computing', 60, 3, 18, 16),
    _r('A2.21', 'Lecture Room 1', 60, 30, 18, 34),
    _r('A2.18', 'Wireless, Mobile & Quantum', 60, 72, 18, 15),
    _r('A2.15', 'Database Technologies', 80, 3, 17, 16),
    _r('A2.14', 'Lecture Room 2', 80, 30, 17, 34),
    _r('A2.10', 'Network, Parallel & Distributed', 80, 72, 17, 15),
    PlanCell('Stairs', 47, 72, 11, 15, CellType.stairs),
  ]);

  // ---- BLOCK B · GROUND (green) · kafeteria links to Block A ----------------
  static final _bGround = FloorArt(100, 52, [
    PlanCell('Stairs', 2, 2, 14, 42, CellType.stairs),
    _r('B0.01 & B0.02', 'Network Lab 1', 18, 2, 26, 20),
    _r('B0.04', 'Network Lab 2 (FYP)', 18, 24, 12, 18),
    _r('B0.05', 'HPC Lab', 31, 24, 13, 18),
    _r('B0.10 & B0.11', 'Software Eng Lab 1', 50, 2, 28, 20),
    _r('B0.07', 'Forensic Lab', 50, 24, 13, 18),
    _r('B0.08', 'Embedded & Robotic Lab', 64, 24, 14, 18),
    PlanCell('Toilet', 80, 2, 16, 14, CellType.toilet),
    PlanCell('Stairs', 80, 18, 16, 24, CellType.stairs),
    PlanCell('Kafeteria', 0, 46, 100, 6, CellType.kafeteria),
  ]);

  // ---- BLOCK B · LEVEL 1 (orange) -----------------------------------------
  static final _b1 = FloorArt(100, 46, [
    PlanCell('Stairs', 2, 2, 14, 42, CellType.stairs),
    _r('B1.04 & B1.05', 'Software System Lab', 18, 2, 24, 20),
    _r('B1.01 & B1.02', 'Database Lab', 18, 24, 24, 18),
    _r('B1.10 & B1.11', 'Perdana Lab', 50, 2, 28, 20),
    _r('B1.07 & B1.08', 'Software Eng Lab 2', 50, 24, 28, 18),
    PlanCell('Toilet', 80, 2, 16, 14, CellType.toilet),
    PlanCell('Stairs', 80, 18, 16, 24, CellType.stairs),
  ]);

  // ---- BLOCK B · LEVEL 2 (blue) -------------------------------------------
  static final _b2 = FloorArt(100, 46, [
    PlanCell('Stairs', 2, 2, 14, 42, CellType.stairs),
    _r('B2.04 & B2.05', 'Al-Khawarizmi Lab', 18, 2, 24, 18),
    _r('B2.01', 'Operating System Lab', 18, 22, 12, 20),
    _r('B2.02', 'Multimedia Studio', 31, 22, 13, 20),
    _r('B2.10 & B2.12', 'Multimedia Lab 2', 50, 2, 28, 18),
    _r('B2.07 & B2.09', 'Multimedia Lab 1', 50, 22, 28, 20),
    PlanCell('Toilet', 80, 2, 16, 14, CellType.toilet),
    PlanCell('Stairs', 80, 18, 16, 24, CellType.stairs),
  ]);
}
