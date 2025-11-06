local Config = {}

Config.LOOP_DELAY = 0.01
Config.SLOTS = {4, 5}

Config.EGG_OPTIONS = {
    "Pumpkin Egg","Bat Egg","Ghost Egg","Cauldron Egg","Spider Egg","Reaper Egg","Coffin Egg","Clown Egg"
}
Config.HOUSE_OPTIONS = {"1","2","3","4","5","6"}

Config.defaults = {
    selectedEgg = Config.EGG_OPTIONS[#Config.EGG_OPTIONS],
    selectedHouse = "6",
    doOpenEggs = true,
    doOpenMaxEggs = false,
    doOpenHouse = true,
    doClaimCandy = true
}

Config.ui = {
    GAP = 8,
    SEP_TOP_PADDING = 8,
    SEP_BOTTOM_PADDING = 12,
    FRAME_WIDTH = 280
}

return Config

