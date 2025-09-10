// test_pet_ui.gml
// Tests for pet panel interaction and functionality

function run_pet_ui_tests() {
    show_debug_message("=== PET UI TESTS ===");
    
    var _passed = 0;
    var _total = 5;
    
    // Test 1: Pet panel script exists
    try {
        // This should fail initially - scr_pet_panel doesn't exist yet
        var _script_exists = script_exists(scr_pet_panel);
        if (_script_exists) {
            show_debug_message("✓ Pet panel script exists");
            _passed++;
        } else {
            show_debug_message("✗ Pet panel script not found");
        }
    } catch (_error) {
        show_debug_message("✗ Pet panel script test error: " + string(_error));
    }
    
    // Test 2: Pet display functionality
    try {
        // Check if pet display functions exist and work
        var _displays_pets = test_pet_display();
        if (_displays_pets) {
            show_debug_message("✓ Pet panel displays pets correctly");
            _passed++;
        } else {
            show_debug_message("✗ Pet panel display not implemented");
        }
    } catch (_error) {
        show_debug_message("✗ Pet display test error: " + string(_error));
    }
    
    // Test 3: Pet selection functionality
    try {
        // Check if pet selection system works
        var _selection_works = test_pet_selection();
        if (_selection_works) {
            show_debug_message("✓ Pet selection system works");
            _passed++;
        } else {
            show_debug_message("✗ Pet selection system not implemented");
        }
    } catch (_error) {
        show_debug_message("✗ Pet selection test error: " + string(_error));
    }
    
    // Test 4: Pet action buttons
    try {
        // Check if pet action buttons work
        var _action_buttons_work = test_pet_action_buttons();
        if (_action_buttons_work) {
            show_debug_message("✓ Pet action buttons functional");
            _passed++;
        } else {
            show_debug_message("✗ Pet action buttons not implemented");
        }
    } catch (_error) {
        show_debug_message("✗ Pet action buttons test error: " + string(_error));
    }
    
    // Test 5: Pet status updates
    try {
        // Check if pet status updates work
        var _status_updates = test_pet_status_updates();
        if (_status_updates) {
            show_debug_message("✓ Pet status updates in real-time");
            _passed++;
        } else {
            show_debug_message("✗ Pet status updates not implemented");
        }
    } catch (_error) {
        show_debug_message("✗ Pet status updates test error: " + string(_error));
    }
    
    show_debug_message("Pet UI Tests: " + string(_passed) + "/" + string(_total) + " passed");
    return (_passed == _total);
}

// Helper functions for individual pet UI tests
function test_pet_panel_script_exists() {
    return script_exists(scr_pet_panel);
}

function test_pet_display() {
    // Check if pet display functions work correctly
    try {
        // Test if we can call the pet panel functions
        // Initialize test pets if they don't exist
        if (!variable_global_exists("pets")) {
            global.pets = [];
            // Create a test pet
            array_push(global.pets, {
                id: 1,
                name: "Test Pet",
                type: "Fire",
                level: 5,
                status: "active"
            });
        }
        
        // Test that we can get pet data
        var pet_data = get_pet_panel_data();
        return (is_struct(pet_data) && array_length(pet_data.pets) > 0);
    } catch(error) {
        return false;
    }
}

function test_pet_selection() {
    // Check if pet selection system works
    try {
        // Use existing pets if they exist, or create new ones
        if (!variable_global_exists("pets") || array_length(global.pets) == 0) {
            global.pets = [];
            // Create a test pet using the proper pet creation system
            var test_pet = create_pet("Test Pet", "Fire");
            array_push(global.pets, test_pet);
        }
        
        // Initialize selected_pet_id if it doesn't exist
        if (!variable_global_exists("selected_pet_id")) {
            global.selected_pet_id = -1;
        }
        
        // Get the first pet's ID for testing (since we don't know what ID it will have)
        var first_pet = global.pets[0];
        
        // Ensure the pet has an ID (add one if missing)
        if (!struct_exists(first_pet, "id")) {
            if (!variable_global_exists("next_pet_id")) {
                global.next_pet_id = 1;
            }
            first_pet.id = global.next_pet_id++;
        }
        
        var test_id = first_pet.id;
        
        // Test selection with first pet's actual ID
        global.selected_pet_id = test_id;
        var selected = get_selected_pet_data();
        
        // Debug output
        show_debug_message("Pet selection test - Selected ID: " + string(global.selected_pet_id));
        show_debug_message("Pet selection test - Pets count: " + string(array_length(global.pets)));
        show_debug_message("Pet selection test - First pet ID: " + string(first_pet.id));
        show_debug_message("Pet selection test - Selected data: " + (is_struct(selected) ? "struct found" : "no struct"));
        if (is_struct(selected)) {
            show_debug_message("Pet selection test - Selected pet ID: " + string(selected.id));
        }
        
        return (is_struct(selected) && selected.id == test_id);
    } catch(error) {
        show_debug_message("Pet selection test error: " + string(error));
        return false;
    }
}

function test_pet_action_buttons() {
    // Check if pet action buttons work
    try {
        // Use existing pets if they exist, or create new ones
        if (!variable_global_exists("pets") || array_length(global.pets) == 0) {
            global.pets = [];
            // Create a test pet using the proper pet creation system
            var test_pet = create_pet("Test Pet", "Fire");
            array_push(global.pets, test_pet);
        }
        
        // Initialize selected_pet_id if it doesn't exist
        if (!variable_global_exists("selected_pet_id")) {
            global.selected_pet_id = -1;
        }
        
        // Get the first pet's ID for testing (since we don't know what ID it will have)
        var first_pet = global.pets[0];
        
        // Ensure the pet has an ID (add one if missing)
        if (!struct_exists(first_pet, "id")) {
            if (!variable_global_exists("next_pet_id")) {
                global.next_pet_id = 1;
            }
            first_pet.id = global.next_pet_id++;
        }
        
        var test_id = first_pet.id;
        
        // Test getting action buttons with first pet's actual ID
        global.selected_pet_id = test_id;
        var actions = get_pet_action_buttons();
        
        // Debug output
        show_debug_message("Pet action buttons test - Actions count: " + string(array_length(actions)));
        
        // Test executing an action
        if (array_length(actions) > 0) {
            var test_action = actions[0].action;
            var action_result = handle_pet_action_click(test_action);
            show_debug_message("Pet action buttons test - Action execution result: " + string(action_result));
            return action_result;
        }
        
        return (is_array(actions) && array_length(actions) > 0);
    } catch(error) {
        show_debug_message("Pet action buttons test error: " + string(error));
        return false;
    }
}

function test_pet_status_updates() {
    // Check if pet status updates work in real-time
    try {
        // Initialize pets if needed
        if (!variable_global_exists("pets") || array_length(global.pets) == 0) {
            global.pets = [{
                id: 1,
                name: "Test Pet",
                type: "Fire", 
                level: 5,
                status: "active"
            }];
        }
        
        // Test update functions
        var update_result = update_pet_panel_data();
        var status_result = update_pet_status_display();
        return (update_result && status_result);
    } catch(error) {
        return false;
    }
}
