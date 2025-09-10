# UI Integration Contract with Existing Game Systems

## Game State Integration Points

### Resource System Integration
**Contract**: UI system reads from existing global.resources without modification

**Required Bindings**:
```gml
// Resource display must reflect these exact values
global.resources.gold     → ResourceDisplayPanel.gold_value
global.resources.wood     → ResourceDisplayPanel.wood_value  
global.resources.metal    → ResourceDisplayPanel.metal_value
global.resources.gems     → ResourceDisplayPanel.gems_value
```

**Update Triggers**:
- Resource values change in any game system
- Save game loaded
- Game state reset

**UI Responsibilities**:
- Format large numbers for readability (1,234 vs 1234)
- Update display within 1 frame of value change
- Maintain visual consistency across all resource types

### Pet System Integration  
**Contract**: UI system displays pet data from global.pets array without modification

**Required Bindings**:
```gml
// For each pet in global.pets array
pet.name                  → PetDisplay.display_name
pet.type                  → PetDisplay.pet_type
pet.level                 → PetDisplay.level_text
pet.status                → PetDisplay.status_text
pet.experience            → PetDisplay.experience_bar
```

**Pet Status Color Mapping**:
- `"idle"` → Green color
- `"exploring"` → Blue color  
- `"battling"` → Red color
- `"returning"` → Yellow color

**Interactive Requirements**:
- Pet selection must update selected_pet variable used by existing pet system
- Pet actions (explore) must call existing pet system functions
- Pet display order must match global.pets array order

### Shop System Integration
**Contract**: UI system displays and interacts with existing shop functions

**Required Function Calls**:
```gml
// Shop display must use existing shop functions
get_shop_items()          → Returns array of available shop items
buy_from_shop(index)      → Existing purchase function
sell_to_shop(index)       → Existing sale function  
can_afford_item(item)     → Check purchase affordability
```

**Shop Mode Activation**:
- Triggered by 'S' key (existing hotkey)
- Must preserve existing shop keyboard shortcuts (1-3, Q-W, ESC)
- UI buttons provide visual alternative to hotkeys

### Crafting System Integration
**Contract**: UI system displays and interacts with existing crafting functions

**Required Function Calls**:
```gml
// Crafting display must use existing crafting functions  
get_crafting_recipes()    → Returns array of available recipes
craft_item(recipe)        → Existing crafting function
can_craft_item(recipe)    → Check resource availability
get_recipe_requirements(recipe) → Get required resources
```

**Crafting Mode Activation**:
- Triggered by 'C' key (existing hotkey)  
- Must preserve existing crafting keyboard shortcuts (1-8, ESC)
- Recipe availability must match existing can_craft_item() logic

### Inventory System Integration
**Contract**: UI system displays inventory from global.inventory without modification

**Required Bindings**:
```gml
// Inventory display must reflect global.inventory array
global.inventory[i].name  → InventorySlot.item_name
global.inventory[i].type  → InventorySlot.item_type
global.inventory[i].quantity → InventorySlot.stack_count
global.inventory[i].quality → InventorySlot.quality_indicator
```

**Item Organization Requirements**:
- Display items in same order as global.inventory array
- Group similar items visually but preserve array order
- Handle dynamic inventory changes (items added/removed)

### Keyboard Shortcut Preservation
**Contract**: All existing keyboard shortcuts must continue to work exactly as before

**Required Hotkey Preservation**:
```gml
// These must continue to work with identical behavior
'H' → Show help (existing function)
'S' → Enter shop mode (existing function)  
'I' → Show status (existing function)
'C' → Enter crafting mode (existing function)
'P' → Enter pet management (existing function)
'T' → Run tests (existing function)
'R' → Reset game (existing function)
'G' → Show user guide (existing function)
'1'-'9' → Context-dependent actions (existing logic)
'Q'-'W' → Shop sell actions (existing logic)
'ESC' → Exit current mode (existing logic)
```

**Input Handling Contract**:
- UI system must NOT intercept keyboard events
- Existing obj_idle_controller keyboard handling preserved  
- UI updates in response to mode changes triggered by hotkeys
- Mouse interactions provide alternative, not replacement

## Display Mode Integration

### Mode State Management
**Contract**: UI system responds to existing display_mode variable

**Mode Mapping Requirements**:
```gml
display_mode = "normal"   → Show default UI layout
display_mode = "shop"     → Show shop panel, highlight shop UI
display_mode = "crafting" → Show crafting panel, highlight crafting UI  
display_mode = "pets"     → Show pet management panel, highlight pets UI
display_mode = "status"   → Show detailed status panel
display_mode = "help"     → Show help panel
```

**Mode Transition Contract**:
- UI panels appear/disappear based on display_mode changes
- Panel transitions should be smooth (animation optional)
- Previous panel state preserved when returning to mode
- No UI changes should modify display_mode variable

### Save/Load System Integration
**Contract**: UI system requires no changes to existing save/load system

**Save System Requirements**:
- UI state is NOT saved (UI reconstructs from game state)
- All UI data derives from existing global variables
- No new save data required for UI functionality
- UI settings (if any) stored in separate UI config file

**Load System Requirements**:
- UI rebuilds completely when game loads
- No assumptions about previous UI state
- All displays update from loaded game state
- UI ready within 1 second of game load completion

## Performance Integration Contract

### Frame Rate Requirements
**Contract**: UI system must not impact existing game performance

**Performance Targets**:
- Game must maintain existing frame rate (target 60fps)
- UI updates only when game state changes (event-driven)
- Drawing operations optimized for GameMaker Draw GUI event
- No continuous polling of game state

### Memory Usage Requirements
**Contract**: UI system memory usage must be minimal and controlled

**Memory Constraints**:
- UI objects allocated once at startup
- No dynamic memory allocation during gameplay
- String operations cached to prevent garbage collection spikes
- UI textures and sprites loaded efficiently

### Integration Testing Requirements
**Contract**: UI system must be testable alongside existing systems

**Testing Integration Points**:
```gml
// UI testing must work with existing test framework
test_ui_resource_display() → Verify resource UI matches game state
test_ui_pet_interactions() → Verify pet UI calls correct functions
test_ui_keyboard_passthrough() → Verify hotkeys still work
test_ui_performance() → Verify no frame rate impact
test_ui_memory_usage() → Verify no memory leaks
```

**Test Data Requirements**:
- UI tests use same test data as existing game system tests
- UI state can be validated by checking visual output matches expected game state
- Integration tests verify UI and game systems work together correctly

This integration contract ensures the UI system enhances the existing game without disrupting any current functionality or requiring changes to the established game architecture.
