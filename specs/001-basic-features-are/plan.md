# Implementation Plan: Comprehensive UI System for Pawn Stars Idle Game

**Branch**: `001-basic-features-are` | **Date**: September 9, 2025 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-basic-features-are/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path ✓
   → Feature spec loaded successfully
2. Fill Technical Context (scan for NEEDS CLARIFICATION) ✓
   → Project Type: GameMaker Studio game project
   → Structure Decision: Single GameMaker project with UI objects/scripts
3. Evaluate Constitution Check section below ✓
   → Working with template constitution - no violations detected
   → Update Progress Tracking: Initial Constitution Check
4. Execute Phase 0 → research.md ✓
   → GameMaker UI research completed
5. Execute Phase 1 → contracts, data-model.md, quickstart.md ✓
   → GameMaker-specific artifacts generated
6. Re-evaluate Constitution Check section ✓
   → No new violations detected
   → Update Progress Tracking: Post-Design Constitution Check
7. Plan Phase 2 → Describe task generation approach ✓
8. STOP - Ready for /tasks command ✓
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
Transform the Pawn Stars Idle Game from a debug text-based interface to a comprehensive visual UI system using GameMaker Studio's built-in UI capabilities. The solution will create dedicated UI objects and drawing routines that display all game information across strategic screen areas while preserving existing keyboard shortcuts. Focus on GameMaker's Draw GUI events and UI elements to create panels for resources, pets, inventory, shop, crafting, and player status.

## Technical Context
**Language/Version**: GameMaker Language (GML) - GameMaker Studio 2024.13.1.193  
**Primary Dependencies**: Built-in GameMaker UI functions (draw_text, draw_rectangle, draw_sprite, etc.)  
**Storage**: Existing JSON save system (savegame.json) - no changes needed  
**Testing**: Existing GML test framework (scr_test_runner.gml)  
**Target Platform**: Desktop (Windows primary, cross-platform GameMaker export)
**Project Type**: Single GameMaker Studio project  
**Performance Goals**: 60 fps UI rendering, responsive button interactions (<100ms)  
**Constraints**: Must work with existing keyboard shortcuts, maintain current save/load system  
**Scale/Scope**: 8 main UI panels, ~20 interactive elements, existing 10 game systems integration

**User Context**: Moving from text-only interface to proper UI with buttons while maintaining keyboard shortcuts. GameMaker Studio 2024.13.1.193 compatibility required.

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Simplicity**:
- Projects: 1 (GameMaker project) ✓
- Using framework directly? Yes (native GameMaker UI functions) ✓
- Single data model? Yes (existing global game state) ✓
- Avoiding patterns? Yes (direct GameMaker object/event system) ✓

**Architecture**:
- EVERY feature as library? GameMaker uses scripts - UI functions in scr_ui_system.gml ✓
- Libraries listed: scr_ui_system.gml (UI rendering and interaction)
- CLI per library: N/A (GameMaker game, not CLI application)
- Library docs: GameMaker inline documentation format ✓

**Testing (NON-NEGOTIABLE)**:
- RED-GREEN-Refactor cycle enforced? Yes (existing test framework) ✓
- Git commits show tests before implementation? Will be enforced ✓
- Order: Contract→Integration→E2E→Unit strictly followed? Adapted for GameMaker ✓
- Real dependencies used? Yes (actual GameMaker runtime) ✓
- Integration tests for: UI panel rendering, button interactions, keyboard shortcuts ✓
- FORBIDDEN: Implementation before test, skipping RED phase ✓

**Observability**:
- Structured logging included? Yes (show_debug_message with structured format) ✓
- Frontend logs → backend? N/A (single application)
- Error context sufficient? Yes (GameMaker debugging) ✓

**Versioning**:
- Version number assigned? 1.1.0 (MAJOR.MINOR.BUILD) ✓
- BUILD increments on every change? Yes ✓
- Breaking changes handled? N/A (single user game) ✓

## Project Structure

### Documentation (this feature)
```
specs/001-basic-features-are/
├── plan.md              # This file (/plan command output) ✓
├── research.md          # Phase 0 output (/plan command) ✓
├── data-model.md        # Phase 1 output (/plan command) ✓
├── quickstart.md        # Phase 1 output (/plan command) ✓
├── contracts/           # Phase 1 output (/plan command) ✓
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### GameMaker Project Structure
```
PSP/ (existing)
├── objects/
│   ├── obj_idle_controller/    # Existing - will be enhanced
│   └── obj_ui_controller/      # New - dedicated UI management
├── scripts/
│   ├── scr_ui_system/         # New - UI rendering functions
│   ├── scr_ui_panels/         # New - individual panel logic
│   └── [existing scripts]     # Enhanced with UI integration
├── sprites/                   # New UI sprites/icons
├── fonts/                     # New fonts for UI text
└── rooms/
    └── Room1/                 # Enhanced with UI layout
```

**Structure Decision**: Single GameMaker project with new UI objects and scripts integrated into existing architecture

## Phase 0: Outline & Research ✓

**GameMaker UI Research completed** - see research.md for detailed findings on:
- GameMaker Studio 2024.13.1.193 UI capabilities and best practices
- Draw GUI event system for persistent UI rendering
- Button interaction patterns using mouse events and collision detection
- Performance optimization for real-time UI updates
- Integration patterns with existing game systems

## Phase 1: Design & Contracts ✓

**GameMaker UI System Design completed**:

1. **UI Data Model** (data-model.md): UI panel structures, button states, layout coordinates
2. **UI Contracts** (contracts/): Interface definitions for UI components and interactions
3. **Integration Tests**: UI panel rendering tests, button interaction tests, keyboard shortcut preservation tests
4. **Quickstart Guide** (quickstart.md): Step-by-step UI implementation and testing process

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `/templates/tasks-template.md` as GameMaker-adapted base
- Generate tasks from UI design (panels, buttons, interactions)
- Each UI panel → panel creation task [P]
- Each button type → interaction test task [P] 
- Each keyboard shortcut → preservation test task
- Integration tasks for existing game systems

**GameMaker-Specific Ordering Strategy**:
- TDD order: UI tests before UI implementation 
- GameMaker dependency order: Objects before scripts before rooms
- UI panel order: Core displays before interactive elements
- Mark [P] for parallel execution (independent objects/scripts)

**Estimated Output**: 20-25 numbered, ordered tasks focusing on GameMaker UI objects, drawing events, and user interaction

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*No constitutional violations requiring justification*

## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented (none)

---
*Based on Constitution template - See `/memory/constitution.md`*