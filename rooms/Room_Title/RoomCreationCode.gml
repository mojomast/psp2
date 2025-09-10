// Room_Title Creation Code
// This code runs when the room is first created

show_debug_message("=== ROOM_TITLE CREATION CODE EXECUTED ===");
show_debug_message("Room width: " + string(room_width) + ", height: " + string(room_height));
show_debug_message("Total instances in room: " + string(instance_count));

// List all instances in the room
with (all) {
    show_debug_message("Instance found: " + object_get_name(object_index) + " at (" + string(x) + "," + string(y) + ")");
}

show_debug_message("=== END ROOM_TITLE CREATION CODE ===");
