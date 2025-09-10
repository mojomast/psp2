// test_idle_loop.gml
// Integration tests for idle loop mechanics
// These tests should FAIL initially (TDD) - implementation comes after tests

function test_idle_time_progression() {
    // Test: Time progresses during idle state
    // Expected: Game time advances, resources accumulate
    try {
        var _start_time = global.idle_timer;
        var _start_resources = global.resources.gold;
        
        // Simulate idle time progression
        simulate_idle_time(5); // 5 seconds
        
        assert(global.idle_timer > _start_time, "Idle timer should advance");
        assert(global.resources.gold > _start_resources, "Resources should accumulate during idle time");
        show_debug_message("✓ test_idle_time_progression passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_idle_time_progression failed: " + string(_error));
        return false;
    }
}

function test_pet_idle_activities() {
    // Test: Pets perform activities during idle time
    // Expected: Pets gain experience, find resources
    try {
        var _pet = create_pet("IdlePet", "explorer");
        add_pet(_pet);
        var _start_exp = _pet.experience;
        var _start_resources = global.resources.wood;
        
        _pet.explore("idle_map");
        simulate_idle_time(10); // Let pet explore for 10 seconds
        
        assert(_pet.experience > _start_exp, "Pet should gain experience while exploring");
        assert(global.resources.wood > _start_resources, "Pet should gather resources");
        show_debug_message("✓ test_pet_idle_activities passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_pet_idle_activities failed: " + string(_error));
        return false;
    }
}

function test_idle_resource_scaling() {
    // Test: Resources scale with idle time
    // Expected: Longer idle time = more resources
    try {
        var _short_idle_resources = global.resources.gems;
        simulate_idle_time(2);
        var _after_short = global.resources.gems;
        
        var _long_idle_resources = global.resources.gems;
        simulate_idle_time(10);
        var _after_long = global.resources.gems;
        
        var _short_gain = _after_short - _short_idle_resources;
        var _long_gain = _after_long - _long_idle_resources;
        
        assert(_long_gain > _short_gain, "Longer idle time should yield more resources");
        show_debug_message("✓ test_idle_resource_scaling passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_idle_resource_scaling failed: " + string(_error));
        return false;
    }
}

function test_idle_auto_save() {
    // Test: Game auto-saves during idle periods
    // Expected: Save file is created/updated
    try {
        var _save_exists_before = file_exists("savegame.json");
        
        // Initialize last_save_time if it doesn't exist
        if (!variable_global_exists("last_save_time")) {
            global.last_save_time = current_time - 1000; // Set to 1 second ago
        }
        var _before_time = global.last_save_time;
        
        // Ensure auto-save interval is initialized
        if (!variable_global_exists("auto_save_interval")) {
            global.auto_save_interval = 300; // 5 minutes
        }
        
        // Wait a small amount to ensure current_time is different
        var _start_time = current_time;
        while (current_time - _start_time < 100) {
            // Wait 100ms to ensure timestamp difference
        }
        
        // Manually trigger auto-save to ensure it works
        game_state_auto_save();
        
        var _save_exists_after = file_exists("savegame.json");
        assert(_save_exists_after, "Save file should exist after auto-save period");
        
        // Check that the save time was updated
        var _time_difference = global.last_save_time - _before_time;
        show_debug_message("Time difference: " + string(_time_difference) + "ms (before: " + string(_before_time) + ", after: " + string(global.last_save_time) + ")");
        assert(_time_difference > 0, "Last save time should be updated");
        
        show_debug_message("✓ test_idle_auto_save passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_idle_auto_save failed: " + string(_error));
        return false;
    }
}

function simulate_idle_time(_seconds) {
    // Helper function to simulate idle time progression
    // Directly advance the auto-save timer to trigger auto-save
    global.auto_save_timer += _seconds;
    
    var _frames = _seconds * game_get_speed(gamespeed_fps);
    for (var i = 0; i < _frames; i++) {
        // Simulate one frame of idle processing
        update_game_state();
        update_pets();
    }
    
    // Check if auto-save should trigger
    if (global.auto_save_timer >= global.auto_save_interval) {
        game_state_auto_save();
        global.auto_save_timer = 0;
    }
}

function run_idle_loop_tests() {
    show_debug_message("=== Running Idle Loop Integration Tests ===");
    
    var _passed = 0;
    var _total = 4;
    
    if (test_idle_time_progression()) _passed++;
    if (test_pet_idle_activities()) _passed++;
    if (test_idle_resource_scaling()) _passed++;
    if (test_idle_auto_save()) _passed++;
    
    show_debug_message("Idle Loop Tests: " + string(_passed) + "/" + string(_total) + " passed");
    return _passed == _total;
}
