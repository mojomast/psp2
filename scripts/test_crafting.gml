// test_crafting.gml
// Integration tests for crafting system
// These tests should FAIL initially (TDD) - implementation comes after tests

function test_basic_crafting() {
    // Test: Craft a simple item
    // Expected: Item is created, resources are consumed
    try {
        // Give player required resources
        global.resources.wood = 10;
        global.resources.metal = 5;
        
        var _recipe = {
            name: "Wooden Sword",
            requirements: {wood: 5, metal: 2},
            result: "wooden_sword"
        };
        
        var _success = craft_item(_recipe);
        assert(_success, "Crafting should succeed with sufficient resources");
        assert(global.resources.wood == 5, "Wood should be consumed");
        assert(global.resources.metal == 3, "Metal should be consumed");
        assert(array_contains(global.inventory, "wooden_sword"), "Item should be in inventory");
        show_debug_message("✓ test_basic_crafting passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_basic_crafting failed: " + string(_error));
        return false;
    }
}

function test_insufficient_resources() {
    // Test: Attempt crafting without enough resources
    // Expected: Crafting fails, resources unchanged
    try {
        global.resources.wood = 2; // Not enough
        global.resources.metal = 5;
        
        var _recipe = {
            name: "Iron Shield",
            requirements: {wood: 5, metal: 10},
            result: "iron_shield"
        };
        
        var _success = craft_item(_recipe);
        assert(!_success, "Crafting should fail with insufficient resources");
        assert(global.resources.wood == 2, "Wood should remain unchanged");
        assert(global.resources.metal == 5, "Metal should remain unchanged");
        show_debug_message("✓ test_insufficient_resources passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_insufficient_resources failed: " + string(_error));
        return false;
    }
}

function test_crafting_upgrade() {
    // Test: Craft an upgrade item
    // Expected: Item provides stat bonuses
    try {
        global.resources.gems = 20;
        
        var _upgrade_recipe = {
            name: "Strength Amulet",
            requirements: {gems: 15},
            result: "strength_amulet",
            bonuses: {attack: 10, health: 5}
        };
        
        var _success = craft_item(_upgrade_recipe);
        assert(_success, "Upgrade crafting should succeed");
        assert(global.resources.gems == 5, "Gems should be consumed");
        
        // Check if upgrade is applied (this would depend on equipment system)
        var _item = find_item_in_inventory("strength_amulet");
        assert(_item != undefined, "Upgrade item should exist");
        assert(_item.bonuses.attack == 10, "Item should have correct attack bonus");
        show_debug_message("✓ test_crafting_upgrade passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_crafting_upgrade failed: " + string(_error));
        return false;
    }
}

function test_bulk_crafting() {
    // Test: Craft multiple items in sequence
    // Expected: All crafting succeeds if resources allow
    try {
        global.resources.wood = 50;
        global.resources.metal = 30;
        
        var _simple_recipe = {
            name: "Arrow",
            requirements: {wood: 2, metal: 1},
            result: "arrow"
        };
        
        var _crafted = 0;
        for (var i = 0; i < 10; i++) {
            if (craft_item(_simple_recipe)) {
                _crafted++;
            } else {
                break; // No more resources
            }
        }
        
        assert(_crafted > 0, "Should be able to craft at least one item");
        assert(_crafted <= 10, "Should not craft more than resources allow");
        show_debug_message("✓ test_bulk_crafting passed");
        return true;
    } catch (_error) {
        show_debug_message("✗ test_bulk_crafting failed: " + string(_error));
        return false;
    }
}

function run_crafting_tests() {
    show_debug_message("=== Running Crafting System Integration Tests ===");
    
    var _passed = 0;
    var _total = 4;
    
    if (test_basic_crafting()) _passed++;
    if (test_insufficient_resources()) _passed++;
    if (test_crafting_upgrade()) _passed++;
    if (test_bulk_crafting()) _passed++;
    
    show_debug_message("Crafting Tests: " + string(_passed) + "/" + string(_total) + " passed");
    return _passed == _total;
}
