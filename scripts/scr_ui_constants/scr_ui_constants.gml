// scr_ui_constants.gml
// UI system constants and color definitions

// UI Color Constants
#macro UI_COLOR_BUTTON_NORMAL make_color_rgb(60, 60, 60)
#macro UI_COLOR_BUTTON_HOVER make_color_rgb(80, 80, 80)
#macro UI_COLOR_BUTTON_PRESSED make_color_rgb(100, 100, 100)
#macro UI_COLOR_BORDER make_color_rgb(100, 100, 100)
#macro UI_COLOR_TEXT c_white
#macro UI_COLOR_PANEL_BG make_color_rgb(30, 30, 30)
#macro UI_COLOR_SELECTED make_color_rgb(100, 150, 100)
#macro UI_COLOR_SLOT_BG make_color_rgb(50, 50, 50)
#macro UI_COLOR_HIGHLIGHT c_yellow

// UI Panel Constants
#macro UI_PANEL_RESOURCES "resources"
#macro UI_PANEL_PETS "pets"
#macro UI_PANEL_SHOP "shop"
#macro UI_PANEL_CRAFTING "crafting"
#macro UI_PANEL_INVENTORY "inventory"

// UI Size Constants
#macro UI_PANEL_WIDTH 300
#macro UI_PANEL_HEIGHT 400
#macro UI_BUTTON_HEIGHT 25
#macro UI_BUTTON_SPACING 5

// Pet Panel Constants
#macro PET_SLOT_SIZE 60
#macro PET_SLOT_SPACING 10

// Feedback Panel Constants
#macro FEEDBACK_MESSAGE_HEIGHT 16
#macro FEEDBACK_MAX_MESSAGES 20

// Timer Constants
#macro IDLE_UPDATE_INTERVAL 1.0  // Update idle income every 1 second
#macro PET_UPDATE_INTERVAL 0.5   // Update pets every 0.5 seconds
#macro AUTOSAVE_INTERVAL 60      // Auto-save every 60 seconds
#macro PET_BONUS_CACHE_TIME 5    // Recache pet bonuses every 5 seconds

// Idle Income Base Values
#macro BASE_GOLD_INCOME 1.0
#macro BASE_WOOD_INCOME 0.5
#macro BASE_METAL_INCOME 0.2
#macro BASE_GEMS_INCOME 0.1

// Pet System Constants
#macro PET_EXPLORE_EXP_PER_SEC 2
#macro PET_EXPLORE_RETURN_CHANCE 0.02
#macro PET_BATTLE_COMPLETE_CHANCE 0.05
#macro PET_LEVEL_EXP_REQUIRED 100

// Shop System Constants
#macro SHOP_SELL_PRICE_RATIO 0.5  // Sell items for 50% of buy price

// Helper function to get all UI panels as array
function ui_get_all_panels() {
    return [UI_PANEL_RESOURCES, UI_PANEL_PETS, UI_PANEL_SHOP, UI_PANEL_CRAFTING, UI_PANEL_INVENTORY];
}
