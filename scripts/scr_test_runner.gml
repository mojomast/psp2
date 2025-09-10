// scr_test_runner.gml
// Test runner for all game systems

function run_all_tests() {
    show_debug_message("=== STARTING TEST SUITE ===");
    
    var _total_passed = 0;
    var _total_tests = 0;
    var _results = [];
    
    // Test Pet System
    try {
        var _pet_passed = run_pet_system_tests();
        _total_passed += _pet_passed ? 4 : 0; // 4 tests in pet system
        _total_tests += 4;
        array_push(_results, "Pet System: " + (_pet_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Pet System Tests Error: " + string(_error));
        array_push(_results, "Pet System: ERROR");
        _total_tests += 4;
    }
    
    // Test Map System
    try {
        var _map_passed = run_map_system_tests();
        _total_passed += _map_passed ? 4 : 0; // 4 tests in map system
        _total_tests += 4;
        array_push(_results, "Map System: " + (_map_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Map System Tests Error: " + string(_error));
        array_push(_results, "Map System: ERROR");
        _total_tests += 4;
    }
    
    // Test Idle Loop
    try {
        var _idle_passed = run_idle_loop_tests();
        _total_passed += _idle_passed ? 4 : 0; // 4 tests in idle loop
        _total_tests += 4;
        array_push(_results, "Idle Loop: " + (_idle_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Idle Loop Tests Error: " + string(_error));
        array_push(_results, "Idle Loop: ERROR");
        _total_tests += 4;
    }
    
    // Test Crafting System
    try {
        var _craft_passed = run_crafting_tests();
        _total_passed += _craft_passed ? 4 : 0; // 4 tests in crafting
        _total_tests += 4;
        array_push(_results, "Crafting: " + (_craft_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Crafting Tests Error: " + string(_error));
        array_push(_results, "Crafting: ERROR");
        _total_tests += 4;
    }
    
    // Test Title Screen (UI Tests Phase 1)
    try {
        var _title_passed = run_title_screen_tests();
        _total_passed += _title_passed ? 4 : 0; // 4 tests in title screen
        _total_tests += 4;
        array_push(_results, "Title Screen: " + (_title_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Title Screen Tests Error: " + string(_error));
        array_push(_results, "Title Screen: ERROR");
        _total_tests += 4;
    }
    
    // Test UI Controller (UI Tests Phase 2)
    try {
        var _ui_controller_passed = run_ui_controller_tests();
        _total_passed += _ui_controller_passed ? 5 : 0; // 5 tests in UI controller
        _total_tests += 5;
        array_push(_results, "UI Controller: " + (_ui_controller_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("UI Controller Tests Error: " + string(_error));
        array_push(_results, "UI Controller: ERROR");
        _total_tests += 5;
    }
    
    // Test UI Panels (UI Tests Phase 3)
    try {
        var _ui_panels_passed = run_ui_panels_tests();
        _total_passed += _ui_panels_passed ? 6 : 0; // 6 tests in UI panels
        _total_tests += 6;
        array_push(_results, "UI Panels: " + (_ui_panels_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("UI Panels Tests Error: " + string(_error));
        array_push(_results, "UI Panels: ERROR");
        _total_tests += 6;
    }
    
    // Test Pet UI (UI Tests Phase 4)
    try {
        var _pet_ui_passed = run_pet_ui_tests();
        _total_passed += _pet_ui_passed ? 5 : 0; // 5 tests in pet UI
        _total_tests += 5;
        array_push(_results, "Pet UI: " + (_pet_ui_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Pet UI Tests Error: " + string(_error));
        array_push(_results, "Pet UI: ERROR");
        _total_tests += 5;
    }
    
    // Test Shop UI (UI Tests Phase 5)
    try {
        var _shop_ui_passed = run_shop_ui_tests();
        _total_passed += _shop_ui_passed ? 6 : 0; // 6 tests in shop UI
        _total_tests += 6;
        array_push(_results, "Shop UI: " + (_shop_ui_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Shop UI Tests Error: " + string(_error));
        array_push(_results, "Shop UI: ERROR");
        _total_tests += 6;
    }
    
    // Test Crafting UI (UI Tests Phase 6)
    try {
        var _crafting_ui_passed = run_crafting_ui_tests();
        _total_passed += _crafting_ui_passed ? 6 : 0; // 6 tests in crafting UI
        _total_tests += 6;
        array_push(_results, "Crafting UI: " + (_crafting_ui_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Crafting UI Tests Error: " + string(_error));
        array_push(_results, "Crafting UI: ERROR");
        _total_tests += 6;
    }
    
    // Test Keyboard UI (UI Tests Phase 7)
    try {
        var _keyboard_ui_passed = run_keyboard_ui_tests();
        _total_passed += _keyboard_ui_passed ? 5 : 0; // 5 tests in keyboard UI
        _total_tests += 5;
        array_push(_results, "Keyboard UI: " + (_keyboard_ui_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Keyboard UI Tests Error: " + string(_error));
        array_push(_results, "Keyboard UI: ERROR");
        _total_tests += 5;
    }
    
    // Test Button System (UI Tests Phase 8)
    try {
        var _button_system_passed = run_button_system_tests();
        _total_passed += _button_system_passed ? 6 : 0; // 6 tests in button system
        _total_tests += 6;
        array_push(_results, "Button System: " + (_button_system_passed ? "PASS" : "FAIL"));
    } catch (_error) {
        show_debug_message("Button System Tests Error: " + string(_error));
        array_push(_results, "Button System: ERROR");
        _total_tests += 6;
    }
    
    // Print results
    show_debug_message("=== TEST RESULTS ===");
    for (var i = 0; i < array_length(_results); i++) {
        show_debug_message(_results[i]);
    }
    show_debug_message("Overall: " + string(_total_passed) + "/" + string(_total_tests) + " tests passed");
    
    if (_total_passed == _total_tests) {
        show_debug_message("🎉 ALL TESTS PASSED! Ready for implementation.");
    } else {
        show_debug_message("❌ Some tests failed. This is expected - implement the missing functions.");
    }
    
    show_debug_message("=== TEST SUITE COMPLETE ===");
    return _total_passed == _total_tests;
}

// Quick test functions for manual testing
function quick_test() {
    show_debug_message("=== QUICK TEST ===");
    show_debug_message("Game initialized: " + string(variable_global_exists("player_name")));
    show_debug_message("Resources initialized: " + string(variable_global_exists("resources")));
    show_debug_message("Pets array exists: " + string(variable_global_exists("pets")));
    show_debug_message("Inventory exists: " + string(variable_global_exists("inventory")));
    show_debug_message("=== QUICK TEST COMPLETE ===");
}
