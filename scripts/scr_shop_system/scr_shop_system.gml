// scr_shop_system.gml
// Pawn shop mechanics for buying/selling items and resources

// Shop inventory is initialized in scr_init_game.gml

// Buy item from shop
function shop_buy_from_shop(_item_index) {
    if (_item_index < 0 || _item_index >= array_length(global.shop_items)) return false;
    
    var _item = global.shop_items[_item_index];
    
    if (global.resources.gold >= _item.price) {
        global.resources.gold -= _item.price;
        
        // Add to inventory
        if (!variable_global_exists("inventory")) {
            global.inventory = [];
        }
        
        var _purchased_item = {
            name: _item.name,
            type: _item.type,
            quantity: 1,
            description: _item.description
        };
        
        array_push(global.inventory, _purchased_item);
        
        show_debug_message("Bought " + _item.name + " for " + string(_item.price) + " gold");
        return true;
    }
    
    show_debug_message("Not enough gold to buy " + _item.name);
    return false;
}

// Sell item to shop
function shop_sell_to_shop(_item_index) {
    if (_item_index < 0 || _item_index >= array_length(global.inventory)) return false;
    
    var _item = global.inventory[_item_index];
    
    // Calculate sell price (50% of buy price)
    var _sell_price = 25; // Default
    
    // Find original price if it's a shop item
    for (var i = 0; i < array_length(global.shop_items); i++) {
        if (global.shop_items[i].name == _item.name) {
            _sell_price = global.shop_items[i].price div 2;
            break;
        }
    }
    
    global.resources.gold += _sell_price;
    
    // Remove from inventory
    array_delete(global.inventory, _item_index, 1);
    
    show_debug_message("Sold " + _item.name + " for " + string(_sell_price) + " gold");
    return true;
}

// Display shop menu (text-based)
function shop_display_shop() {
    show_debug_message("=== PAWN SHOP ===");
    show_debug_message("Gold: " + string(global.resources.gold));
    show_debug_message("");
    show_debug_message("Items for sale:");
    
    for (var i = 0; i < array_length(global.shop_items); i++) {
        var _item = global.shop_items[i];
        show_debug_message(string(i) + ". " + _item.name + " - " + string(_item.price) + " gold");
        show_debug_message("   " + _item.description);
    }
    
    show_debug_message("");
    show_debug_message("Your inventory:");
    if (array_length(global.inventory) == 0) {
        show_debug_message("Empty");
    } else {
        for (var i = 0; i < array_length(global.inventory); i++) {
            var _item = global.inventory[i];
            show_debug_message(string(i) + ". " + _item.name + " (Sell for " + string(25) + " gold)");
        }
    }
    
    show_debug_message("");
    show_debug_message("Shop shortcuts: Press 1-3 to buy, Q-W to sell, ESC to exit");
}

// Process shop command
function shop_process_shop_command(_command) {
    var _parts = string_split(_command, " ");
    
    if (array_length(_parts) < 1) return;
    
    var _action = _parts[0];
    
    if (_action == "exit") {
        // Handled by caller
        return;
    }
    
    if (array_length(_parts) < 2) return;
    
    var _index = real(_parts[1]);
    
    if (_action == "buy") {
        shop_buy_from_shop(_index);
    } else if (_action == "sell") {
        shop_sell_to_shop(_index);
    }
}
