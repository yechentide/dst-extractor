---@diagnostic disable: undefined-global, need-check-nil
os.exit(0)

local xxx_descriptions = {
	{ text = STRINGS.UI.SANDBOXMENU.SLIDENEVER, data = "never" },
	{ text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default" },
    { text = STRINGS.UI.SANDBOXMENU.ALWAYS, data = "always" },
}
local yyy_descriptions = {
	{ text = STRINGS.UI.SANDBOXMENU.SLIDENEVER, data = "never" },
	{ text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default" },
    { text = STRINGS.UI.SANDBOXMENU.ALWAYS, data = "always" },
}

local WORLDGEN_GROUP = {
	["monsters"] = {
		order = 5,
		text = STRINGS.UI.SANDBOXMENU.WORLDGENERATION_HOSTILE_CREATURES,
		desc = xxx_descriptions,
		atlas = "images/worldgen_customization.xml",
		items={
			["tentacles"] = {
                value = "default",
                image = "tentacles.tex",
                world={"forest", "cave"}
            },
			["ocean_waterplant"] = {
                value = "ocean_default",
                image = "ocean_waterplant.tex",
                desc = yyy_descriptions,
                world = {"forest"}
            },
		}
	},
	["global"] = {
		order = 1,
		text = STRINGS.UI.SANDBOXMENU.CHOICEGLOBAL,
		desc = nil,
		atlas = "images/worldgen_customization.xml",
		items = {
			["season_start"] = {
                value = "default",
                image = "season_start.tex",
                options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
                desc = yyy_descriptions,
                master_controlled = true, order = 1
            },
		},
        -- master_group = WORLDGEN_GROUP,
        -- group_name = "global",
        -- category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS / nil
	},
}
local WORLDGEN_MISC = {
	"has_ocean",
	"keep_disconnected_tiles",
	"layout_mode",
	"no_joining_islands",
	"no_wormholes_to_disconnected_tiles",
	"wormhole_prefab",
}
local MOD_WORLDGEN_GROUP = {}
local MOD_WORLDGEN_MISC = {}

local WORLDSETTINGS_GROUP = {
	["giants"] = {
		order = 8,
		text = STRINGS.UI.SANDBOXMENU.CHOICEGIANTS,
		desc = xxx_descriptions,
		atlas = "images/worldsettings_customization.xml",
		items={
			["liefs"] = {
                value = "default",
                image = "liefs.tex",
                world={"forest", "cave"}
            },
			["deciduousmonster"] = {
                value = "default",
                image = "deciduouspoison.tex",
                world={"forest"}
            },
		}
	},
	["resources"] = {
		order= 4,
		text = STRINGS.UI.SANDBOXMENU.WORLDSETTINGS_RESOURCEREGROWTH,
		desc = xxx_descriptions,
		atlas = "images/worldsettings_customization.xml",
		items={
			["basicresource_regrowth"] = {
                value = "none",
                image = "basicresource_regrowth.tex",
                desc = yyy_descriptions,
                masteroption = true,
                master_controlled = true,
                master_sync = true
            },
		}
	},
	["misc"] = {
		order= 3,
		text = STRINGS.UI.SANDBOXMENU.CHOICEMISC,
		desc = nil,
		atlas = "images/worldsettings_customization.xml",
		items={
			["lightning"] = {
                value = "default",
                image = "lightning.tex",
                desc = xxx_descriptions,
                world={"forest"}
            },
            ["rifts_enabled_cave"] = {
                value = "default",
                image = "shadowrift_portal.tex",
                desc = yyy_descriptions,
                world={"cave"}
            },
		}
	},
	["global"] = {
		order = 0,
		text = STRINGS.UI.SANDBOXMENU.CHOICEGLOBAL,
		desc = nil,
		atlas = "images/worldsettings_customization.xml",
		items = {
			["autumn"] = {
                value = "default",
                image = "autumn.tex",
                options_remap = {img = "blank_season_yellow.tex", atlas = "images/customisation.xml"},
                desc = xxx_descriptions,
                master_controlled = true,
                order = 2
            },
			["krampus"] = {
                value = "default",
                image = "krampus.tex",
                desc = yyy_descriptions,
                masteroption = true,
                master_controlled = true,
                master_sync = true,
                order = 13
            },
		}
	},
}
local WORLDSETTINGS_MISC = {}
local MOD_WORLDSETTINGS_GROUP = {}
local MOD_WORLDSETTINGS_MISC = {}

local EXEMPT_OPTIONS = {
	specialevent = true,
	spawnprotection = true,
    hallowed_nights = true,
    winters_feast = true,
    crow_carnival = true,
    year_of_the_gobbler = true,
    year_of_the_varg = true,
    year_of_the_pig = true,
    year_of_the_carrat = true,
    year_of_the_beefalo = true,
    year_of_the_catcoon = true,
    year_of_the_bunnyman = true,
}

local OPTIONS = {
    ["season_start"] = {
        name = "season_start",
        master_group = WORLDGEN_GROUP,
        group = WORLDGEN_GROUP["global"],
        category = LEVELCATEGORY.WORLDGEN, -- nil
        value = "default",
        image = "season_start.tex",
        options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
        desc = yyy_descriptions,
        master_controlled = true, order = 1
    },
    ["tentacles"] = {
        name = "tentacles",
        master_group = WORLDGEN_GROUP,
        group = WORLDGEN_GROUP["monsters"],
        category = LEVELCATEGORY.WORLDGEN, -- nil
        value = "default",
        image = "tentacles.tex",
        world={"forest", "cave"}
    },
    ["ocean_waterplant"] = {
        name = "ocean_waterplant",
        master_group = WORLDGEN_GROUP,
        group = WORLDGEN_GROUP["monsters"],
        category = LEVELCATEGORY.WORLDGEN, -- nil
        value = "ocean_default",
        image = "ocean_waterplant.tex",
        desc = yyy_descriptions,
        world = {"forest"}
    },
    ["liefs"] = {
        name = "liefs",
        master_group = WORLDSETTINGS_GROUP,
        group = WORLDSETTINGS_GROUP["giants"],
        category = LEVELCATEGORY.SETTINGS, -- nil
        value = "default",
        image = "liefs.tex",
        world={"forest", "cave"}
    },
    ["basicresource_regrowth"] = {
        name = "basicresource_regrowth",
        master_group = WORLDSETTINGS_GROUP,
        group = WORLDSETTINGS_GROUP["resources"],
        category = LEVELCATEGORY.SETTINGS, -- nil
        value = "none",
        image = "basicresource_regrowth.tex",
        desc = yyy_descriptions,
        masteroption = true,
        master_controlled = true,
        master_sync = true
    },
}

local OPTIONS_MISC = {
	["has_ocean"] = {
        name = "has_ocean",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
	["has_ocekeep_disconnected_tilesan"] = {
        name = "keep_disconnected_tiles",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
	["layout_mode"] = {
        name = "layout_mode",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
	["no_joining_islands"] = {
        name = "no_joining_islands",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
	["no_wormholes_to_disconnected_tiles"] = {
        name = "no_wormholes_to_disconnected_tiles",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
	["wormhole_prefab"] = {
        name = "wormhole_prefab",
        category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
    },
}

local MOD_OPTIONS = {
    -- ---------- not sure
    -- ["modname"] = {
    --     ["name"] = true,
    -- }
}
local MOD_OPTIONS_MISC = {
    -- ---------- not sure
    -- ["modname"] = {
    --     ["name"] = {
    --         category = LEVELCATEGORY.WORLDGEN,
    --     }
    -- }
}

local MOD_DISABLE_GROUP = {}
local MOD_DISABLE_ITEM = {}

-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- Functions
-- ---------- ---------- ---------- ---------- ---------- ---------- --

-- ---------- MOD_DISABLE_GROUP[category][groupname] が存在する、かつ空テーブルではないなら、true
-- 戻り値:
-- true / false
local function IsGroupDisabled(category, groupname) end

-- ---------- MOD_DISABLE_ITEM[itemname] が存在する、かつ空テーブルではないなら、true
-- 戻り値:
-- true / false
local function IsItemDisabled(itemname) end

-- ---------- OPTIONS[override] / MOD_OPTIONS[???][override] で取り出す
-- ---------- IsGroupDisabled() == true && IsItemDisabled() = true なら nil を返す
-- 戻り値:
-- {
--     name = "season_start",
--     master_group = WORLDGEN_GROUP,
--     group = WORLDGEN_GROUP["global"],
--     category = LEVELCATEGORY.WORLDGEN, -- nil
--     value = "default",
--     image = "season_start.tex",
--     options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
--     desc = yyy_descriptions,
--     master_controlled = true, order = 1
-- }
local function GetOption(override) end

-- ---------- OPTIONS_MISC[override] / MOD_OPTIONS_MISC[???][override] で取り出す
-- ---------- IsItemDisabled() == true なら nil を返す
-- 戻り値:
-- {
--     name = "has_ocean",
--     category = LEVELCATEGORY.WORLDGEN, -- LEVELCATEGORY.SETTINGS
-- }
local function GetMiscOption(override) end

-- depreciated: local function GetGroupForOption(target) return nil end

local ITEM_EXPORTS = {
	atlas = "",         -- function(item)           -> item.atlas / item.group.atlas
	name = "",          -- function(item)           -> item.name
	image = "",         -- function(item)           -> item.image
	options = {},       -- function(item, location) -> item.desc / item.group.desc, 関数であるなら location を引数として渡して、関数を実行
	default = "",       -- function(item)           -> item.value
	group = "",         -- function(item)           -> item.group.group_name
	grouplabel = "",    -- function(item)           -> item.group.text end,
	widget_type = "",   -- function(item)           -> item.widget_type / "optionsspinner"
	options_remap = {}, -- function(item)           -> item.options_remap
}

local DUPLICATE_AND_MOVE = {
	["flowers"] = "flowers_regrowth",
	["flower_cave"] = "flower_cave_regrowth",
}

-- 引数:
-- { "season_start" = "default", "tentacles" = "default" }
-- ---------- OPTIONS[override] / MOD_OPTIONS[???][override] から取り出して、
-- ---------- category == LEVELCATEGORY.SETTINGS なら、同じオプション名でセット
-- 戻り値:
-- DUPLICATE_AND_MOVE に存在するなら、返還後のオプション名でセット
-- {
--     "season_start" = { name = "", master_group = {}, group = {}, category = nil, value = "", image = "", desc = {}, },
-- }
local function GetWorldSettingsFromLevelSettings(overrides) end

-- 説明:
-- OPTIONS から、
-- IsGroupDisabled() と IsItemDisabled() が両方false, かつ option.masteroption == true の時だけデータを取り出す
-- Modの設定なら、MOD_OPTIONS から masteroption == true のデータを取り出す
-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- 戻り値:
-- {
--     ["season_start"] = {
--         name = "season_start",
--         master_group = WORLDGEN_GROUP,
--         group = WORLDGEN_GROUP["global"],
--         category = LEVELCATEGORY.WORLDGEN, -- nil
--         value = "default",
--         image = "season_start.tex",
--         options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
--         desc = yyy_descriptions,
--         master_controlled = true, order = 1
--     },
--   ["tentacles"] = {
--         name = "tentacles",
--         master_group = WORLDGEN_GROUP,
--         group = WORLDGEN_GROUP["monsters"],
--         category = LEVELCATEGORY.WORLDGEN, -- nil
--         value = "default",
--         image = "tentacles.tex",
--         world={"forest", "cave"}
--     },
-- }
local function GetMasterOptions() end

-- 説明:
-- OPTIONS から、
-- IsGroupDisabled() と IsItemDisabled() が両方false, かつ option.master_sync == true の時だけデータを取り出す
-- Modの設定なら、MOD_OPTIONS から master_sync == true のデータを取り出す
-- ---------- ---------- ---------- ---------- ---------- ---------- --
-- 戻り値:
-- {
--     ["season_start"] = {
--         name = "season_start",
--         master_group = WORLDGEN_GROUP,
--         group = WORLDGEN_GROUP["global"],
--         category = LEVELCATEGORY.WORLDGEN, -- nil
--         value = "default",
--         image = "season_start.tex",
--         options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
--         desc = yyy_descriptions,
--         master_controlled = true, order = 1
--     },
--   ["tentacles"] = {
--         name = "tentacles",
--         master_group = WORLDGEN_GROUP,
--         group = WORLDGEN_GROUP["monsters"],
--         category = LEVELCATEGORY.WORLDGEN, -- nil
--         value = "default",
--         image = "tentacles.tex",
--         world={"forest", "cave"}
--     },
-- }
local function GetSyncOptions() end

-- only used for validating settings
-- OPTIONS と MOD_OPTIONS からデータを取り出して、１つのテーブルにまとめる
-- データを取り出す際に、以下の条件を満たさないものを取り除く
--     location == nil || option.world == nil || table.contains(option.world, location)
--     &&
--     is_master_world || !option.master_controlled
-- 戻り値:
-- {
--     ["season_start"] = {
--         name = "season_start",
--         group = WORLDGEN_GROUP["global"],
--         default = "default",
--         options = {},
--     },
-- }
local function GetOptions(location, is_master_world) end

-- GROUP と MOD_GROUP からデータを ITEM_EXPORTSにある関数で 取り出して、一つのテーブルにまとめる
-- データを取り出す際に、以下の条件を満たさないものを取り除く
--     !IsGroupDisabled() && !IsItemDisabled()
--     &&
--     location == nil || option.world == nil || table.contains(option.world, location)
--     &&
--     is_master_world || !option.master_controlled
-- 戻り値:
-- {
--     ["season_start"] = {
--         atlas = "",         -- function(item)           -> item.atlas / item.group.atlas
--         name = "",          -- function(item)           -> item.name
--         image = "",         -- function(item)           -> item.image
--         options = {},       -- function(item, location) -> item.desc / item.group.desc, 関数であるなら location を引数として渡して、関数を実行
--         default = "",       -- function(item)           -> item.value
--         group = "",         -- function(item)           -> item.group.group_name
--         grouplabel = "",    -- function(item)           -> item.group.text end,
--         widget_type = "",   -- function(item)           -> item.widget_type / "optionsspinner"
--         options_remap = {}, -- function(item)           -> item.options_remap
--     },
-- }
local function GetOptionsFromGroup(GROUP, MOD_GROUP, location, is_master_world) end

-- GetOptionsFromGroup() で、WORLDGEN_GROUP と MOD_WORLDGEN_GROUP からデータを取り出す
local function GetWorldGenOptions(location, is_master_world) end

-- GetOptionsFromGroup() で、WORLDSETTINGS_GROUP と MOD_WORLDSETTINGS_GROUP からデータを取り出す
local function GetWorldSettingsOptions(location, is_master_world) end

-- 次の指定された location(Level) データのデフォルト値(overridesにある値)を、GetOptions() の戻り値の各 option の default に設定する
-- {
--     id = "LAVAARENA",
--     name = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.LAVAARENA,
--     desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.LAVAARENA,
--     location = "lavaarena", -- this is actually the prefab name
--     version = 4,
--     overrides={
--         boons = "never",
--         touchstone = "never",
--         traps = "never",
--         poi = "never",
--         protected = "never",
--     },
--     background_node_range = {0,1},
-- }
local function GetOptionsWithLocationDefaults(location, is_master_world) end

-- 次の指定された location(Level) データのデフォルト値(overridesにある値)を、GetWorldGenOptions() の戻り値の各 option の default に設定する
-- {
--     id = "LAVAARENA",
--     name = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.LAVAARENA,
--     desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.LAVAARENA,
--     location = "lavaarena", -- this is actually the prefab name
--     version = 4,
--     overrides={
--         boons = "never",
--         touchstone = "never",
--         traps = "never",
--         poi = "never",
--         protected = "never",
--     },
--     background_node_range = {0,1},
-- }
local function GetWorldGenOptionsWithLocationDefaults(location, is_master_world) end

-- 次の指定された location(Level) データのデフォルト値(overridesにある値)を、GetWorldSettingsOptions() の戻り値の各 option の default に設定する
-- {
--     id = "LAVAARENA",
--     name = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.LAVAARENA,
--     desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.LAVAARENA,
--     location = "lavaarena", -- this is actually the prefab name
--     version = 4,
--     overrides={
--         boons = "never",
--         touchstone = "never",
--         traps = "never",
--         poi = "never",
--         protected = "never",
--     },
--     background_node_range = {0,1},
-- }
local function GetWorldSettingsOptionsWithLocationDefaults(location, is_master_world) end

-- GetOptions() の戻り値から、指定された option のデフォルト値を取得する
local function GetDefaultForOption(option_name) end

-- 指定された location(Level) データの、特定の option のデフォルト値を取得する
-- 戻り値:
-- "xxxxxx" / nil
local function GetLocationDefaultForOption(location, option) end

local function ValidateOption(option_name, option_value, location) end

-- 値が選択肢にあるのかを検証する
-- 戻り値:
-- true / false
local function ValidateOption(option_name, option_value, location) end

-- 指定された option のカテゴリを取得する
-- 戻り値:
-- LEVELCATEGORY.WORLDGEN / .LEVEL / .SETTINGS / .COMBINED / nil
local function GetCategoryForOption(option_name) end

-- デフォルト設定にあるかを検証する
-- 戻り値:
-- true / false
local function IsCustomizeOption(option_name) end

-- WORLDGEN_GROUP, WORLDSETTINGS_GROUP, MOD_WORLDGEN_GROUP, MOD_WORLDSETTINGS_GROUP から、指定されたグループを取得する
-- 戻り値 01:
-- {
--     order = 0,
--     text = STRINGS.UI.SANDBOXMENU.CHOICEGLOBAL,
--     desc = nil,
--     atlas = "images/worldsettings_customization.xml",
--     items = {
--         ["autumn"] = {
--             value = "default",
--             image = "autumn.tex",
--             options_remap = {img = "blank_season_yellow.tex", atlas = "images/customisation.xml"},
--             desc = xxx_descriptions,
--             master_controlled = true,
--             order = 2
--         },
--         ["krampus"] = {
--             value = "default",
--             image = "krampus.tex",
--             desc = yyy_descriptions,
--             masteroption = true,
--             master_controlled = true,
--             master_sync = true,
--             order = 13
--         },
--     }
-- }
-- 戻り値 02:
-- WORLDGEN_GROUP
local function GetGroupFromName(category, group) end

-- 指定された option のキーを取得する
-- 戻り値:
-- {
--     name = "season_start",
--     master_group = WORLDGEN_GROUP,
--     group = WORLDGEN_GROUP["global"],
--     category = LEVELCATEGORY.WORLDGEN, -- nil
--     value = "default",
--     image = "season_start.tex",
--     options_remap = {img = "blank_season_red.tex", atlas = "images/customisation.xml"},
--     desc = yyy_descriptions,
--     master_controlled = true, order = 1
-- }
local function GetItemFromName(name) end

-- MOD_WORLDGEN_GROUP または MOD_WORLDSETTINGS_GROUP にカスタマイズグループを追加する
local function AddCustomizeGroup(modname, category, name, text, desc, atlas, order) end
-- MOD_DISABLE_GROUP も更新される
local function RemoveCustomizeGroup(modname, category, name) end

-- 指定されたグループと MOD_OPTIONS に設定を追加
-- パラメータが２つ目までの場合、MOD_GROUP_MISC と MOD_OPTIONS_MISC に追加
local function AddCustomizeItem(modname, category, group, name, itemsettings) end
-- MOD_DISABLE_ITEM も更新される
local function RemoveCustomizeItem(modname, category, name) end

-- 全選択肢一覧から、特定の選択肢グループを取得する
local function GetDescription(description) end

-- 引数なし:
--     MOD_WORLDGEN_MISC, MOD_WORLDSETTINGS_MISC がクリアされる
--     MOD_OPTIONS, MOD_OPTIONS_MISC がクリアされる
--     MOD_WORLDGEN_GROUP, MOD_WORLDSETTINGS_GROUP がクリアされる
--     WORLDGEN_GROUP, WORLDSETTINGS_GROUP, MOD_WORLDGEN_GROUP, MOD_WORLDSETTINGS_GROUP 内の関連設定も消される
-- 引数あり:
--     上の各テーブルから、関連Modの設定のみクリアされる

---comment
---@param modname string
local function ClearModData(modname) end

return {
	--BACKEND ONLY
	GetOptions                     				= GetOptions,
	GetOptionsWithLocationDefaults 				= GetOptionsWithLocationDefaults,

	GetWorldSettingsOptions		   				= GetWorldSettingsOptions,
	GetWorldSettingsOptionsWithLocationDefaults = GetWorldSettingsOptionsWithLocationDefaults,

	GetWorldGenOptions			   				= GetWorldGenOptions,
	GetWorldGenOptionsWithLocationDefaults 		= GetWorldGenOptionsWithLocationDefaults,

	GetWorldSettingsFromLevelSettings			= GetWorldSettingsFromLevelSettings,

	GetMasterOptions							= GetMasterOptions,
	GetSyncOptions								= GetSyncOptions,

    GetLocationDefaultForOption    				= GetLocationDefaultForOption,
	ValidateOption                 				= ValidateOption,

	--modding interface
	AddCustomizeGroup							= AddCustomizeGroup,
	RemoveCustomizeGroup						= RemoveCustomizeGroup,
	AddCustomizeItem							= AddCustomizeItem,
	RemoveCustomizeItem							= RemoveCustomizeItem,

	GetDescription								= GetDescription,
	ITEM_EXPORTS				   				= ITEM_EXPORTS,

	ClearModData								= ClearModData,
	GetDefaultForOption            				= GetDefaultForOption,
	GetCategoryForOption						= GetCategoryForOption,
	IsCustomizeOption							= IsCustomizeOption,
	GetGroupForOption              				= GetGroupForOption, --depreciated
}
