// Debug controller Create Event
show_debug_message("=== DEBUG CONTROLLER CREATED ===");
show_debug_message("Starting room: " + room_get_name(room));

// Make this object persistent so it stays across rooms
persistent = true;

// Set up some counters
frame_count = 0;
debug_interval = 60; // Show debug info every 60 frames (1 second at 60fps)
