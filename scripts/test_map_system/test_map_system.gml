// test_map_system.gml
// Contract tests for map system
// These tests should FAIL initially (TDD) - implementation comes after tests

function test_map_generation() {
    // Test: Generate a new map
    // Expected: Returns valid map data structure
    try {
        var _seed = 12345;
        var _size = 10;
        var _difficulty = 1;
        
        var _map = generate_map(_seed, _size, _difficulty);
        assert(_map != undefined, "Map generation should return data");
        assert(is_array(_map.tiles) || ds_exists(_map.tiles, ds_type_grid), "Map should have tiles");
        assert(_map.size == _size, "Map size should match requested size");
        assert(_map.difficulty == _difficulty, "Map difficulty should match requested");
        show_debug_message("✓ test_map_generation passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_map_generation failed: " + string(_error));
        return false;
    }
}

function test_map_validation() {
    // Test: Validate generated map
    // Expected: Returns true for valid maps, false for invalid
    try {
        var _valid_map = generate_map(12345, 10, 1);
        var _is_valid = validate_map(_valid_map);
        assert(_is_valid == true, "Valid map should pass validation");
        
        // Test invalid map
        var _invalid_map = {size: -1, tiles: undefined};
        var _is_invalid = validate_map(_invalid_map);
        assert(_is_invalid == false, "Invalid map should fail validation");
        
        show_debug_message("✓ test_map_validation passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_map_validation failed: " + string(_error));
        return false;
    }
}

function test_spawn_point() {
    // Test: Get spawn point from map
    // Expected: Returns valid coordinates within map bounds
    try {
        var _map = generate_map(54321, 15, 2);
        var _spawn = get_spawn_point(_map);
        
        assert(is_struct(_spawn) || is_array(_spawn), "Spawn point should be coordinates");
        assert(_spawn.x >= 0 && _spawn.x < _map.size, "Spawn X should be within map bounds");
        assert(_spawn.y >= 0 && _spawn.y < _map.size, "Spawn Y should be within map bounds");
        show_debug_message("✓ test_spawn_point passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_spawn_point failed: " + string(_error));
        return false;
    }
}

function test_map_exits() {
    // Test: Get exit points from map
    // Expected: Returns array of valid exit coordinates
    try {
        var _map = generate_map(99999, 12, 3);
        var _exits = get_exits(_map);
        
        assert(is_array(_exits), "Exits should be an array");
        assert(array_length(_exits) > 0, "Map should have at least one exit");
        
        // Check each exit is valid
        for (var i = 0; i < array_length(_exits); i++) {
            var _exit = _exits[i];
            assert(_exit.x >= 0 && _exit.x < _map.size, "Exit X should be within bounds");
            assert(_exit.y >= 0 && _exit.y < _map.size, "Exit Y should be within bounds");
        }
        
        show_debug_message("✓ test_map_exits passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_map_exits failed: " + string(_error));
        return false;
    }
}

function run_map_system_tests() {
    show_debug_message("=== Running Map System Contract Tests ===");
    
    var _passed = 0;
    var _total = 4;
    
    if (test_map_generation()) _passed++;
    if (test_map_validation()) _passed++;
    if (test_spawn_point()) _passed++;
    if (test_map_exits()) _passed++;
    
    show_debug_message("Map System Tests: " + string(_passed) + "/" + string(_total) + " passed");
    return _passed == _total;
}
