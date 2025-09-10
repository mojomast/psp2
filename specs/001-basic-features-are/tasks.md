# Tasks: Comprehensive UI System for Pawn Stars Idle Game

**Input**: Design documents from `/specs/001-basic-features-are/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/, quickstart.md

## Execution Flow (main)
```
1. Load plan.md from feature directory ✓
   → GameMaker Studio 2024.13.1.193 project with UI panels and title screen
   → Extract: GameMaker objects, scripts, UI panels structure
2. Load optional design documents: ✓
   → data-model.md: UI panel entities and layout coordinates
   → contracts/: UI interface definitions and game integration contracts
   → research.md: GameMaker UI best practices and performance considerations
3. Generate tasks by category: ✓
   → Setup: GameMaker objects, scripts, sprites, fonts
   → Tests: UI panel tests, interaction tests, integration tests
   → Core: Title screen, UI panels, drawing systems, button interactions
   → Integration: Existing game system connections, keyboard shortcuts
   → Polish: animations, performance optimization, visual polish
4. Apply task rules: ✓
   → Different GameMaker objects/scripts = mark [P] for parallel
   → Same script files = sequential (no [P])
   → Tests before implementation (TDD adapted for GameMaker)
5. Number tasks sequentially (T001, T002...) ✓
6. Generate dependency graph ✓
7. Create parallel execution examples ✓
8. Validate task completeness: ✓
   → All UI panels have tests and implementations
   → All existing systems have UI integration
   → Title screen and game screens properly connected
9. Return: SUCCESS (tasks ready for execution) ✓
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different GameMaker objects/scripts, no dependencies)
- Include exact GameMaker file paths in descriptions

## GameMaker Project Structure
**Base Path**: `c:\Users\kyle\projects\gamemaker\psp3\PSP\`
- **Objects**: `objects/obj_name/`
- **Scripts**: `scripts/scr_name/`  
- **Sprites**: `sprites/spr_name/`
- **Fonts**: `fonts/fnt_name/`
- **Rooms**: `rooms/Room_name/`

## Phase 3.1: Setup and Assets
- [x] T001 [P] Create title screen sprite assets in `sprites/spr_title_logo/`
- [x] T002 [P] Create UI icon sprites for resources in `sprites/spr_ui_icons/`
- [x] T003 [P] Create UI button sprites in `sprites/spr_ui_buttons/`
- [x] T004 [P] Create UI font for main interface in `fonts/fnt_ui_main/`
- [x] T005 [P] Create title screen font in `fonts/fnt_title/`

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [x] T006 [P] Title screen navigation test in `scripts/test_title_screen/test_title_screen.gml`
- [ ] T007 [P] UI controller initialization test in `scripts/test_ui_controller/test_ui_controller.gml`
- [ ] T008 [P] Resource panel display test in `scripts/test_ui_panels/test_ui_panels.gml`
- [ ] T009 [P] Pet panel interaction test in `scripts/test_pet_ui/test_pet_ui.gml`
- [ ] T010 [P] Shop panel functionality test in `scripts/test_shop_ui/test_shop_ui.gml`
- [ ] T011 [P] Crafting panel integration test in `scripts/test_crafting_ui/test_crafting_ui.gml`
- [ ] T012 [P] Keyboard shortcut preservation test in `scripts/test_keyboard_ui/test_keyboard_ui.gml`
- [ ] T013 [P] Button interaction test in `scripts/test_button_system/test_button_system.gml`

## Phase 3.3: Core Implementation (ONLY after tests are failing)

### Title Screen System
- [x] T014 [P] Title screen controller object in `objects/obj_title_controller/obj_title_controller.yy`
- [x] T015 [P] Title screen room setup in `rooms/Room_Title/Room_Title.yy`
- [x] T016 Title screen drawing system in `objects/obj_title_controller/Draw_64.gml`
- [x] T017 Title screen input handling in `objects/obj_title_controller/Step_0.gml`

### Core UI Infrastructure  
- [x] T018 [P] UI controller object in `objects/obj_ui_controller/obj_ui_controller.yy`
- [x] T019 [P] UI system core script in `scripts/scr_ui_system/scr_ui_system.gml`
- [x] T020 [P] UI panel base functions in `scripts/scr_ui_panels/scr_ui_panels.gml`
- [x] T021 [P] Button system script in `scripts/scr_ui_buttons/scr_ui_buttons.gml`

### UI Controller Events
- [x] T022 UI controller initialization in `objects/obj_ui_controller/Create_0.gml`
- [x] T023 UI controller drawing system in `objects/obj_ui_controller/Draw_64.gml`  
- [x] T024 UI controller mouse handling in `objects/obj_ui_controller/Step_0.gml`

### Individual UI Panels
- [ ] T025 [P] Resource display panel functions in `scripts/scr_resource_panel/scr_resource_panel.gml`
- [ ] T026 [P] Player status panel functions in `scripts/scr_player_panel/scr_player_panel.gml`
- [ ] T027 [P] Pet management panel functions in `scripts/scr_pet_panel/scr_pet_panel.gml`
- [ ] T028 [P] Inventory panel functions in `scripts/scr_inventory_panel/scr_inventory_panel.gml`
- [ ] T029 [P] Shop interface panel functions in `scripts/scr_shop_panel/scr_shop_panel.gml`
- [ ] T030 [P] Crafting panel functions in `scripts/scr_crafting_panel/scr_crafting_panel.gml`
- [ ] T031 [P] Action feedback panel functions in `scripts/scr_feedback_panel/scr_feedback_panel.gml`

## Phase 3.4: Integration with Existing Systems
- [x] T032 Integrate UI controller with existing idle controller in `objects/obj_idle_controller/Create_0.gml`
- [x] T033 Connect resource display to global.resources in UI system
- [x] T034 Connect pet display to global.pets array in UI system
- [x] T035 Connect shop display to existing shop functions in UI system
- [x] T036 Connect crafting display to existing crafting system in UI system
- [x] T037 Preserve keyboard shortcuts in UI system integration
- [x] T038 Connect inventory display to global.inventory in UI system
- [ ] T039 Update existing draw events to work with new UI system
- [ ] T040 Add room transitions between title and game screens

## Phase 3.5: Interactive Features
- [ ] T041 [P] Button click detection system in button script
- [ ] T042 [P] Panel mode switching (shop/crafting/pets) in UI controller
- [ ] T043 [P] Mouse hover feedback for buttons in UI system  
- [ ] T044 Pet selection and action buttons integration
- [ ] T045 Shop buy/sell button functionality integration
- [ ] T046 Crafting recipe selection and craft buttons integration
- [ ] T047 Inventory item interaction and tooltip system

## Phase 3.6: Polish and Optimization
- [ ] T048 [P] UI animation system for smooth transitions in `scripts/scr_ui_animations/scr_ui_animations.gml`
- [ ] T049 [P] Performance optimization for UI updates in UI system
- [ ] T050 [P] Visual polish: colors, spacing, alignment across all panels
- [ ] T051 [P] Error handling for UI edge cases in UI controller
- [ ] T052 [P] UI accessibility improvements (keyboard navigation) in UI system
- [ ] T053 Run comprehensive UI testing validation
- [ ] T054 Performance testing: maintain 60fps with full UI active
- [ ] T055 Final integration testing with all existing game systems

## Dependencies

### Critical Path Dependencies
- **Assets (T001-T005)** before **UI Implementation (T014+)**
- **Tests (T006-T013)** before **Implementation (T014-T031)**  
- **Core Infrastructure (T018-T024)** before **Panel Implementation (T025-T031)**
- **Panel Implementation (T025-T031)** before **Integration (T032-T040)**
- **Integration (T032-T040)** before **Interactive Features (T041-T047)**
- **Everything** before **Polish (T048-T055)**

### Specific Dependencies
- T014 requires T001, T005 (title screen assets)
- T018-T024 require T002-T004 (UI assets)  
- T025-T031 require T018-T020 (UI infrastructure)
- T032-T040 require T025-T031 (panels exist)
- T041-T047 require T021, T032-T040 (button system and integration)
- T048-T055 require all previous tasks

## Parallel Execution Examples

### Phase 1: Asset Creation (can run simultaneously)
```bash
# Launch T001-T005 together:
Task: "Create title screen sprite assets in sprites/spr_title_logo/"
Task: "Create UI icon sprites for resources in sprites/spr_ui_icons/"  
Task: "Create UI button sprites in sprites/spr_ui_buttons/"
Task: "Create UI font for main interface in fonts/fnt_ui_main/"
Task: "Create title screen font in fonts/fnt_title/"
```

### Phase 2: Test Creation (can run simultaneously)  
```bash
# Launch T006-T013 together:
Task: "Title screen navigation test in scripts/test_title_screen/test_title_screen.gml"
Task: "UI controller initialization test in scripts/test_ui_controller/test_ui_controller.gml"
Task: "Resource panel display test in scripts/test_ui_panels/test_ui_panels.gml"
Task: "Pet panel interaction test in scripts/test_pet_ui/test_pet_ui.gml"
```

### Phase 3: Core Objects (can run simultaneously)
```bash
# Launch T014, T015, T018-T021 together:
Task: "Title screen controller object in objects/obj_title_controller/obj_title_controller.yy"
Task: "Title screen room setup in rooms/Room_Title/Room_Title.yy"
Task: "UI controller object in objects/obj_ui_controller/obj_ui_controller.yy"
Task: "UI system core script in scripts/scr_ui_system/scr_ui_system.gml"
```

### Phase 4: Panel Scripts (can run simultaneously)
```bash
# Launch T025-T031 together:
Task: "Resource display panel functions in scripts/scr_resource_panel/scr_resource_panel.gml"
Task: "Player status panel functions in scripts/scr_player_panel/scr_player_panel.gml"
Task: "Pet management panel functions in scripts/scr_pet_panel/scr_pet_panel.gml"
Task: "Inventory panel functions in scripts/scr_inventory_panel/scr_inventory_panel.gml"
```

## Special GameMaker Considerations

### Room Management
- Title screen uses `Room_Title` as starting room
- Main game uses existing `Room1` enhanced with UI
- Proper room_goto() transitions between screens

### Object Depth Management  
- UI objects at negative depths (draw on top)
- Title screen controller at depth -1000
- UI controller at depth -999
- Preserve existing game object depths

### Event System Integration
- Draw GUI events for persistent UI rendering
- Step events for real-time updates
- Mouse events for button interactions
- Preserve existing keyboard event handling

### Performance Targets
- Maintain existing 60fps performance
- UI updates only on game state changes  
- Efficient string caching for resource displays
- Minimal memory allocation during gameplay

## Validation Checklist
*GATE: Checked before task execution begins*

- [x] All UI panels have corresponding tests (T006-T013)
- [x] All UI entities from data model have implementation tasks (T025-T031)
- [x] All tests come before implementation (Phase 3.2 before 3.3)
- [x] Parallel tasks truly independent (different objects/scripts)
- [x] Each task specifies exact GameMaker file path
- [x] No task modifies same file as another [P] task
- [x] Title screen system properly designed and integrated
- [x] All existing game systems have UI integration tasks
- [x] Keyboard shortcut preservation explicitly tested and maintained

## Notes
- **[P] tasks**: Different GameMaker objects/scripts, no file conflicts
- **Sequential tasks**: Same object events (Create, Draw, Step)
- **TDD Adaptation**: GameMaker tests verify UI state and interactions
- **Asset Pipeline**: Sprites and fonts created before implementation
- **Integration Focus**: Preserve all existing functionality while adding UI
- **Title Screen**: Professional game entry point with smooth transitions
