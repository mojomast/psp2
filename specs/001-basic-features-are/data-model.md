# Data Model: UI System for Pawn Stars Idle Game

## UI Panel Entities

### ResourceDisplayPanel
**Purpose**: Shows current resource counters (gold, wood, metal, gems)
**Location**: Top of screen, horizontal layout

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions
- `background_color`: Panel background color
- `border_color`: Panel border color
- `icon_sprites`: Array of resource icon sprites
- `text_color`: Resource counter text color
- `font`: Font used for resource numbers

**Data Sources**:
- `global.resources.gold`
- `global.resources.wood` 
- `global.resources.metal`
- `global.resources.gems`

**Update Triggers**:
- Resource values change
- Game state load/save

### PlayerStatusPanel  
**Purpose**: Displays player information and progress
**Location**: Top-right corner

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions
- `player_name`: Display name
- `level`: Current player level
- `experience`: Current experience points
- `experience_to_next`: Experience needed for next level
- `playtime`: Total time played formatted string

**Data Sources**:
- `global.player_name`
- `global.player_level`
- `global.player_experience` 
- `global.idle_timer`

**State Transitions**:
- Level up: Update display with level change animation
- Experience gain: Update progress bar

### PetManagementPanel
**Purpose**: Lists all pets with status and interaction options
**Location**: Left side of screen

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions
- `pet_list`: Array of pet display objects
- `selected_pet_index`: Currently selected pet (-1 if none)
- `scroll_offset`: For scrolling when many pets

**Pet Display Object**:
- `pet_reference`: Reference to actual pet in global.pets
- `display_name`: Pet name for UI
- `status_text`: Current status (idle/exploring/battling)
- `level_text`: Level display
- `status_color`: Color coding for status
- `is_selected`: Boolean for selection highlighting

**Interactions**:
- Click pet: Select for actions
- Click explore button: Send pet exploring
- Keyboard 1-9: Select pet by index

### InventoryPanel
**Purpose**: Shows all owned items with organization
**Location**: Right side of screen

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions
- `item_grid`: 2D array of item display slots
- `scroll_offset`: For scrolling through items
- `filter_type`: Current item type filter (all/weapons/consumables/etc)

**Item Display Slot**:
- `item_reference`: Reference to actual item in global.inventory
- `icon_sprite`: Item icon sprite
- `quantity`: Stack quantity (if applicable)
- `quality_color`: Color coding for item quality
- `tooltip_text`: Detailed item description

**Organization Rules**:
- Group by item type (weapons, consumables, resources)
- Sort by quality within type
- Stack similar items where applicable

### ShopPanel
**Purpose**: Displays available shop items for purchase/sale
**Location**: Bottom area when shop mode active

**Attributes**:
- `x, y`: Panel position coordinates  
- `width, height`: Panel dimensions
- `shop_items`: Array of shop item displays
- `player_items`: Array of sellable inventory items
- `is_buy_mode`: Boolean for buy vs sell mode
- `selected_item_index`: Currently highlighted item

**Shop Item Display**:
- `item_reference`: Reference to shop item
- `name`: Item name
- `price`: Cost in gold
- `description`: Item description text
- `can_afford`: Boolean for affordability
- `button_state`: Available/disabled/highlighted

**Interactions**:
- Click item: Purchase/sell
- Keyboard 1-3: Buy items 0-2
- Keyboard Q-W: Sell items 0-1
- ESC: Exit shop mode

### CraftingPanel
**Purpose**: Shows available recipes and crafting options
**Location**: Bottom area when crafting mode active

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions  
- `recipe_list`: Array of recipe displays
- `selected_recipe_index`: Currently selected recipe

**Recipe Display**:
- `recipe_reference`: Reference to actual recipe
- `name`: Recipe name
- `requirements`: Array of required resources
- `result_item`: What gets crafted
- `can_craft`: Boolean for resource availability
- `requirement_colors`: Green/red for available/missing resources

**Interactions**:
- Click recipe: Craft item
- Keyboard 1-8: Craft recipes 0-7
- ESC: Exit crafting mode

### ActionFeedbackPanel
**Purpose**: Shows status messages and action confirmations
**Location**: Bottom of screen

**Attributes**:
- `x, y`: Panel position coordinates
- `width, height`: Panel dimensions
- `message_queue`: Array of pending messages
- `current_message`: Currently displayed message
- `message_timer`: Time remaining for current message
- `message_color`: Color for message type (success/error/info)

**Message Object**:
- `text`: Message content
- `duration`: How long to display (seconds)
- `type`: Message type (success/error/info/warning)
- `timestamp`: When message was created

### UIState
**Purpose**: Manages overall UI state and coordination
**Attributes**:
- `current_mode`: Active UI mode (normal/shop/crafting/pets)
- `previous_mode`: Previous mode for ESC handling
- `ui_enabled`: Global UI enable/disable flag
- `mouse_over_ui`: Boolean for mouse UI interaction
- `keyboard_focus`: Which panel has keyboard focus
- `layout_dirty`: Flag for when UI needs repositioning
- `animation_states`: Array of active UI animations

## UI Layout Coordinates

### Screen Division Strategy
**Total Screen**: 1024x768 (default GameMaker resolution)

**Panel Layout**:
```
+-----------------------------------------------------------+
| Resource Panel (0,0,1024,60)                             |
|                                    Player Status (824,0) |
+-----------------------------------------------------------+
| Pet Panel    |                              | Inventory  |
| (0,60,       |        Main Game Area        | Panel      |
|  200,600)    |       (200,60,824,500)       | (824,60,   |
|              |                              |  200,600)  |
+-----------------------------------------------------------+
| Action/Shop/Crafting Panel (0,600,1024,168)              |
+-----------------------------------------------------------+
```

**Responsive Considerations**:
- Panels scale proportionally with window size
- Minimum panel sizes maintained for readability
- Text scaling based on panel dimensions

## Button Interaction Areas

### Button State Model
**States**: normal, hover, pressed, disabled
**Attributes**:
- `x, y, width, height`: Click area boundaries
- `current_state`: Active button state
- `callback_function`: Function to call on click
- `keyboard_shortcut`: Associated hotkey
- `tooltip_text`: Hover description

### Collision Detection
**Method**: Rectangle collision with mouse position
**Implementation**: 
- Check mouse_x, mouse_y within button bounds
- Handle mouse_check_button_pressed(mb_left)
- Provide hover feedback on mouse_check_button(mb_any)

## Animation System

### UI Transitions
**Panel Slide**: Panels slide in/out when mode changes
**Button Feedback**: Buttons scale slightly when clicked
**Resource Updates**: Numbers animate when values change
**Status Changes**: Pet status icons animate on state change

**Animation Properties**:
- `start_value`: Beginning value
- `end_value`: Target value  
- `duration`: Animation time in frames
- `easing_function`: Animation curve type
- `current_frame`: Progress through animation

## Integration Points

### Existing Game System Connections
- **global.resources**: Direct binding to ResourceDisplayPanel
- **global.pets**: Direct binding to PetManagementPanel
- **global.inventory**: Direct binding to InventoryPanel
- **global.shop_items**: Direct binding to ShopPanel
- **display_mode**: Controls which panels are active

### Event Triggers
- Resource changes → Update ResourceDisplayPanel
- Pet status changes → Update PetManagementPanel  
- Inventory changes → Update InventoryPanel
- Mode changes → Show/hide appropriate panels
- Keyboard input → Route to appropriate panel

## Validation Rules

### Display Constraints
- Resource values: Format large numbers with commas
- Pet names: Truncate if longer than panel width
- Item descriptions: Word wrap within tooltip bounds
- Status messages: Queue and rotate if too many

### Interaction Constraints  
- Only one panel can have keyboard focus
- Modal panels (shop/crafting) disable other interactions
- Hotkeys work regardless of mouse focus
- Button clicks must complete before next click accepted

## Performance Considerations

### Update Frequency
- **Every Frame**: Mouse hover states, animations
- **On Change**: Resource displays, pet status, inventory
- **On Mode Switch**: Panel visibility, button states
- **On Load**: Full UI reconstruction from game state

### Memory Management
- Cache formatted strings for static text
- Reuse button objects rather than recreating
- Limit animation objects to prevent memory leaks
- Use object pooling for temporary UI elements

This data model provides the complete structure for implementing the UI system while maintaining clean separation between display logic and game logic.
