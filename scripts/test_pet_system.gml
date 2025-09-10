// test_pet_system.gml
// Contract tests for pet system
// These tests should FAIL initially (TDD) - implementation comes after tests

function test_pet_creation() {
    // Test: Create a new pet
    // Expected: Returns pet struct with required properties
    try {
        var _pet = create_pet("Fluffy", "dog");
        assert(_pet != undefined, "Pet creation should return a struct");
        assert(_pet.name == "Fluffy", "Pet name should be set correctly");
        assert(_pet.type == "dog", "Pet type should be set correctly");
        assert(_pet.level == 1, "Pet should start at level 1");
        assert(is_array(_pet.stats), "Pet should have stats array");
        show_debug_message("✓ test_pet_creation passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_pet_creation failed: " + string(_error));
        return false;
    }
}

function test_pet_exploration() {
    // Test: Send pet to explore a map
    // Expected: Pet status changes to exploring
    try {
        var _pet = create_pet("TestPet", "cat");
        var _map_id = "test_map_001";
        
        _pet.explore(_map_id);
        assert(_pet.status == "exploring", "Pet status should be 'exploring'");
        assert(_pet.current_map == _map_id, "Pet should be assigned to correct map");
        show_debug_message("✓ test_pet_exploration passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_pet_exploration failed: " + string(_error));
        return false;
    }
}

function test_pet_battle() {
    // Test: Pet engages in battle
    // Expected: Pet status changes and stats are affected
    try {
        var _pet = create_pet("Warrior", "dragon");
        var _original_health = _pet.stats.health;
        
        _pet.battle();
        assert(_pet.status == "battling", "Pet status should be 'battling'");
        // Note: Actual health changes depend on battle outcome
        show_debug_message("✓ test_pet_battle passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_pet_battle failed: " + string(_error));
        return false;
    }
}

function test_pet_level_up() {
    // Test: Pet gains experience and levels up
    // Expected: Level increases when enough XP gained
    try {
        var _pet = create_pet("Grower", "rabbit");
        var _original_level = _pet.level;
        
        // Simulate gaining experience
        _pet.experience += 100;
        _pet.level_up();
        
        assert(_pet.level > _original_level, "Pet level should increase");
        assert(_pet.experience >= 0, "Pet experience should be valid");
        show_debug_message("✓ test_pet_level_up passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_pet_level_up failed: " + string(_error));
        return false;
    }
}

function run_pet_system_tests() {
    show_debug_message("=== Running Pet System Contract Tests ===");
    
    var _passed = 0;
    var _total = 4;
    
    if (test_pet_creation()) _passed++;
    if (test_pet_exploration()) _passed++;
    if (test_pet_battle()) _passed++;
    if (test_pet_level_up()) _passed++;
    
    show_debug_message("Pet System Tests: " + string(_passed) + "/" + string(_total) + " passed");
    return _passed == _total;
}
