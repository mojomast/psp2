# UI System Interface Contracts

## IUIPanel Interface
**Purpose**: Standard interface for all UI panels in the system

**Required Functions**:
```gml
// Initialize panel with position and size
function init_panel(x, y, width, height)

// Draw the panel and its contents
function draw_panel()

// Update panel state (called when game state changes)  
function update_panel()

// Handle mouse click events within panel
// Returns true if click was handled, false otherwise
function handle_click(mouse_x, mouse_y)

// Handle keyboard input when panel has focus
// Returns true if key was handled, false otherwise  
function handle_keyboard(key_pressed)

// Check if mouse is over any interactive element
function is_mouse_over()

// Set panel visibility
function set_visible(visible)

// Get panel bounds for collision detection
function get_bounds()
```

**Required Properties**:
- `panel_x, panel_y`: Panel position
- `panel_width, panel_height`: Panel dimensions  
- `is_visible`: Visibility state
- `is_enabled`: Interactive state
- `panel_id`: Unique identifier

## IButton Interface  
**Purpose**: Standard interface for clickable UI buttons

**Required Functions**:
```gml
// Initialize button with area and callback
function init_button(x, y, width, height, callback_func, text)

// Draw button based on current state
function draw_button()

// Update button state based on mouse position
function update_button_state(mouse_x, mouse_y)

// Handle button click
function on_button_click()

// Set button enabled/disabled state
function set_enabled(enabled)

// Set button text
function set_text(text)
```

**Required Properties**:
- `button_x, button_y, button_width, button_height`: Click area
- `button_state`: Current state (normal/hover/pressed/disabled)
- `button_text`: Display text
- `callback_function`: Function to call on click
- `is_enabled`: Interactive state

## IResourceDisplay Interface
**Purpose**: Interface for displaying game resources

**Required Functions**:
```gml
// Initialize resource display
function init_resource_display(resource_type, x, y)

// Update displayed value from game state  
function update_resource_value()

// Draw resource icon and value
function draw_resource()

// Format resource value for display
function format_value(value)

// Get current displayed value
function get_display_value()
```

**Required Properties**:
- `resource_type`: Type of resource (gold/wood/metal/gems)
- `current_value`: Currently displayed value
- `display_x, display_y`: Position coordinates
- `icon_sprite`: Resource icon sprite
- `value_format`: Number formatting style

## IPetDisplay Interface
**Purpose**: Interface for displaying pet information

**Required Functions**:  
```gml
// Initialize pet display with pet reference
function init_pet_display(pet_ref, x, y, width, height)

// Update display from pet data
function update_pet_data()

// Draw pet information
function draw_pet_info()

// Handle pet selection
function select_pet()

// Handle pet action (explore, status, etc)
function perform_pet_action(action)

// Check if this pet display was clicked
function is_pet_clicked(mouse_x, mouse_y)
```

**Required Properties**:
- `pet_reference`: Reference to pet in global.pets
- `display_bounds`: Display area coordinates
- `is_selected`: Selection state
- `status_color`: Color for status indication

## IInventorySlot Interface
**Purpose**: Interface for inventory item display slots

**Required Functions**:
```gml
// Initialize slot with position
function init_inventory_slot(x, y, slot_width, slot_height)

// Set item data for this slot
function set_slot_item(item_data)

// Clear slot (remove item)
function clear_slot()

// Draw slot and item if present
function draw_inventory_slot()

// Handle slot click (use item, show tooltip, etc)
function on_slot_click()

// Show item tooltip on hover
function show_item_tooltip()
```

**Required Properties**:
- `slot_x, slot_y, slot_width, slot_height`: Slot bounds
- `item_data`: Current item in slot (null if empty)
- `is_occupied`: Boolean for slot state
- `tooltip_text`: Item description text

## IShopItem Interface
**Purpose**: Interface for shop item displays

**Required Functions**:
```gml
// Initialize shop item display
function init_shop_item(item_data, x, y, width, height)

// Update affordability based on player resources
function update_affordability()

// Draw item with price and availability
function draw_shop_item()

// Handle purchase attempt
function attempt_purchase()

// Handle sale attempt (for inventory items)  
function attempt_sale()
```

**Required Properties**:
- `item_data`: Shop item information
- `display_bounds`: Item display area
- `can_afford`: Boolean for purchase availability
- `item_price`: Cost in resources
- `is_buyable`: True for shop items, false for player items

## ICraftingRecipe Interface
**Purpose**: Interface for crafting recipe displays

**Required Functions**:
```gml
// Initialize recipe display
function init_crafting_recipe(recipe_data, x, y, width, height)

// Update craftability based on available resources
function update_recipe_status()

// Draw recipe with requirements and result
function draw_crafting_recipe()

// Handle crafting attempt
function attempt_craft()

// Show detailed recipe requirements
function show_recipe_details()
```

**Required Properties**:
- `recipe_data`: Recipe information and requirements
- `display_bounds`: Recipe display area  
- `can_craft`: Boolean for crafting availability
- `requirement_status`: Array of requirement fulfillment states

## IMessageDisplay Interface
**Purpose**: Interface for status messages and feedback

**Required Functions**:
```gml
// Add new message to display queue
function add_message(text, type, duration)

// Update message display (handle timing, queue)
function update_message_display()

// Draw current message
function draw_current_message()

// Clear all messages
function clear_messages()

// Set message display area
function set_message_area(x, y, width, height)
```

**Required Properties**:
- `message_queue`: Array of pending messages
- `current_message`: Currently displayed message
- `display_area`: Message display bounds
- `message_timer`: Remaining display time

## Contract Validation Rules

### Panel Contracts
1. All panels MUST implement IUIPanel interface
2. Panel drawing MUST be contained within panel bounds
3. Panel updates MUST only occur when underlying data changes
4. Panel click handling MUST return boolean for event consumption

### Button Contracts  
1. All buttons MUST implement IButton interface
2. Button states MUST be visually distinct
3. Disabled buttons MUST not respond to clicks
4. Button callbacks MUST be non-blocking

### Display Contracts
1. Resource displays MUST update when global resource values change
2. Pet displays MUST reflect current pet status accurately
3. Inventory slots MUST handle empty states gracefully
4. Shop items MUST show correct affordability status

### Interaction Contracts
1. Only one UI element can have focus at a time
2. Keyboard shortcuts MUST work regardless of mouse focus
3. Modal panels MUST disable background interactions
4. UI updates MUST not interrupt user interactions

### Performance Contracts
1. Drawing functions MUST complete within 16ms (60fps)
2. Update functions MUST be event-driven, not per-frame
3. Memory allocations MUST be minimized during gameplay
4. String formatting MUST be cached for repeated values

These contracts ensure consistent behavior across all UI components and provide clear integration points for the existing game systems.
