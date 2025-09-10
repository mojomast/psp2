// scr_test_runner.gml
// Test runner for all game systems

function test_run_all_tests() {
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
function test_quick_test() {
    show_debug_message("=== QUICK TEST ===");
    show_debug_message("Game initialized: " + string(variable_global_exists("player_name")));
    show_debug_message("Resources initialized: " + string(variable_global_exists("resources")));
    show_debug_message("Pets array exists: " + string(variable_global_exists("pets")));
    show_debug_message("Inventory exists: " + string(variable_global_exists("inventory")));
    show_debug_message("=== QUICK TEST COMPLETE ===");
}
