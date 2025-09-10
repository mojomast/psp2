// Create Event - Initialize game
show_debug_message("=== PAWN STARS IDLE GAME INITIALIZING ===");

// Enable application surface for drawing
application_surface_enable(true);
application_surface_draw_enable(true);

// Center the window
window_center();

// Make sure the object is visible and has proper depth
visible = true;
depth = -1000; // Ensure it draws on top

show_debug_message("Object visibility: " + string(visible));
show_debug_message("Object depth: " + string(depth));
show_debug_message("Room width: " + string(room_width) + ", height: " + string(room_height));

// Initialize global variables
init_game_state();

// Initialize display state
display_mode = "normal"; // normal, shop, help, status
last_key_time = 0;
last_status_update = 0; // Track last status update time
selected_pet = undefined; // For pet selection

show_debug_message("Game initialized successfully. Display mode: " + display_mode);

// User guide functions
function show_user_guide() {
    show_debug_message("=== PAWN STARS IDLE GAME - USER GUIDE ===");
    show_debug_message("");
    show_debug_message("🎯 WELCOME TO PAWN STARS IDLE!");
    show_debug_message("   Your journey as a pawn shop owner begins here.");
    show_debug_message("   Build your empire through idle resource gathering,");
    show_debug_message("   pet exploration, crafting, and trading!");
    show_debug_message("");

    show_debug_message("🎮 GETTING STARTED");
    show_debug_message("   • Click on the game window to focus it");
    show_debug_message("   • Press H for help, S for shop, I for status");
    show_debug_message("   • Resources accumulate automatically over time");
    show_debug_message("   • Your pet 'Buddy' is ready for adventure!");
    show_debug_message("");

    show_debug_message("⌨️ CONTROLS");
    show_debug_message("   T - Run test suite (developer mode)");
    show_debug_message("   R - Reset game to starting state");
    show_debug_message("   S - Open pawn shop (browse items)");
    show_debug_message("   I - Show detailed player status");
    show_debug_message("   C - Open crafting system");
    show_debug_message("   P - Manage pets");
    show_debug_message("   H - Show this help");
    show_debug_message("   G - Full user guide");
    show_debug_message("");

    show_debug_message("💰 RESOURCE SYSTEM");
    show_debug_message("   • Gold: Primary currency for buying items");
    show_debug_message("   • Wood: Used for crafting basic items");
    show_debug_message("   • Metal: Used for crafting advanced items");
    show_debug_message("   • Gems: Rare resource for special items");
    show_debug_message("   • Resources generate automatically based on:");
    show_debug_message("     - Your player level");
    show_debug_message("     - Number and level of idle pets");
    show_debug_message("     - Time played");
    show_debug_message("");

    show_debug_message("🐾 PET SYSTEM");
    show_debug_message("   • Pets explore maps to gather resources");
    show_debug_message("   • Different pet types have unique bonuses:");
    show_debug_message("     - Dog: Higher attack for battles");
    show_debug_message("     - Cat: Higher speed for exploration");
    show_debug_message("     - Dragon: Higher health and attack");
    show_debug_message("     - Rabbit: Higher luck for rare finds");
    show_debug_message("     - Explorer: Balanced stats for adventuring");
    show_debug_message("   • Pets level up through experience");
    show_debug_message("   • Higher level pets gather more resources");
    show_debug_message("");

    show_debug_message("🗺️ EXPLORATION");
    show_debug_message("   • Send pets to explore different maps");
    show_debug_message("   • Maps have different difficulty levels");
    show_debug_message("   • Higher difficulty = better rewards");
    show_debug_message("   • Exploration takes time but yields resources");
    show_debug_message("   • Pets return automatically when done");
    show_debug_message("");

    show_debug_message("🏪 PAWN SHOP");
    show_debug_message("   • Buy items with gold");
    show_debug_message("   • Sell items from your inventory");
    show_debug_message("   • Items include weapons, resources, consumables");
    show_debug_message("   • Press S to enter shop");
    show_debug_message("   • Press 1-3 to buy items 0-2");
    show_debug_message("   • Press Q-W to sell items 0-1");
    show_debug_message("   • Press ESC to exit shop");
    show_debug_message("");

    show_debug_message("🔨 CRAFTING SYSTEM");
    show_debug_message("   • Combine resources to create items");
    show_debug_message("   • Use wood, metal, and gems for recipes");
    show_debug_message("   • Crafted items can be sold for profit");
    show_debug_message("   • Higher quality items sell for more");
    show_debug_message("   • Press C to enter crafting");
    show_debug_message("   • Press 1-8 to craft items 0-7");
    show_debug_message("   • Press ESC to exit crafting");
    show_debug_message("");

    show_debug_message("🐾 PET MANAGEMENT");
    show_debug_message("   • Press P to enter pet management");
    show_debug_message("   • Press 1-9 to select pets 0-8");
    show_debug_message("   • Press E to send selected pet exploring");
    show_debug_message("   • Press ESC to exit pet management");
    show_debug_message("   • Gain experience through pet activities");
    show_debug_message("   • Level up to increase resource generation");
    show_debug_message("   • Unlock new pets and abilities");
    show_debug_message("   • Build your pawn shop empire!");
    show_debug_message("");

    show_debug_message("💾 SAVING & LOADING");
    show_debug_message("   • Game auto-saves every minute");
    show_debug_message("   • Progress is saved to savegame.json");
    show_debug_message("   • Game loads automatically on startup");
    show_debug_message("   • Use R to reset if needed");
    show_debug_message("");

    show_debug_message("🎯 GAMEPLAY TIPS");
    show_debug_message("   • Keep multiple pets exploring for best results");
    show_debug_message("   • Balance between gathering and selling items");
    show_debug_message("   • Higher level pets = more resources per second");
    show_debug_message("   • Don't forget to check the shop regularly");
    show_debug_message("   • The game runs best when focused");
    show_debug_message("");

    show_debug_message("🔧 TROUBLESHOOTING");
    show_debug_message("   • If controls don't work: Click game window first");
    show_debug_message("   • If game is slow: Close other programs");
    show_debug_message("   • If display issues: Check debug console");
    show_debug_message("   • If save corrupted: Delete savegame.json and restart");
    show_debug_message("");

    show_debug_message("📞 SUPPORT");
    show_debug_message("   • Check debug console for detailed messages");
    show_debug_message("   • Press T to run tests and verify functionality");
    show_debug_message("   • Report issues with console output");
    show_debug_message("");

    show_debug_message("=== END OF USER GUIDE ===");
    show_debug_message("💡 Press H anytime to see this guide again!");
}

// ...existing code...

// ...existing code...

show_debug_message("=== GAME READY ===");
show_debug_message("=== CONTROLS ===");
show_debug_message("T - Run test suite");
show_debug_message("R - Reset game state");
show_debug_message("S - Open pawn shop");
show_debug_message("I - Show player status");
show_debug_message("C - Open crafting system");
show_debug_message("P - Manage pets");
show_debug_message("H - Show this help");
    show_debug_message("Shop shortcuts: Press 1-3 to buy items 0-2, Q-W to sell items 0-1, ESC to exit shop");
    show_debug_message("Crafting shortcuts: Press 1-8 to craft items 0-7, ESC to exit crafting");
    show_debug_message("Pet shortcuts: Press 1-9 to select pets 0-8, E to explore, ESC to exit pets");
show_debug_message("=== ENJOY YOUR IDLE ADVENTURE! ===");
show_debug_message("💰 Resources are accumulating automatically...");
show_debug_message("🐕 Your pet 'Buddy' is ready for adventure!");

// Show complete user guide on startup
show_user_guide();
