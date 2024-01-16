# Required

## files

- **`map/customize.lua`**
    - import: map/tasksets, map/startlocations, map/levels, ~~map/tasks~~, ~~worldsettings_overrides~~
    - variables: STRINGS, SPECIAL_EVENTS, LEVELCATEGORY
    - functions: FunctionOrValue, GetTableSize, deepcopy, IsTableEmpty
    - classes: ~~TheFrontEnd~~
- `map/tasksets`
    - import: ✅map/tasksets/forest, ✅map/tasksets/caves, ✅map/tasksets/lavaarena, ✅map/tasksets/quagmire
    - functions: deepcopy, moderror
- `map/startlocations`
    - functions: deepcopy, moderror
    - classes: ~~TheFrontEnd~~, ModManager
- `map/levels`
    - import:
        - _map/customize_, map/level, ✅map/settings, ✅map/locations
        - ✅map/levels/forest, ✅map/levels/caves, ✅map/levels/lavaarena, ✅map/levels/quagmire
    - variables: LEVELTYPE, LEVELCATEGORY, DEFAULT_LOCATION
    - functions: global, deepcopy, MergeMapsDeep, moderror
    - classes: CustomPresetManager, Profile, Level
- `map/level`
    - import: map/resource_substitution, _map/tasksets_, ~~map/tasks~~
    - variables: Class
    - classes: ModManager
- `map/resource_substitution`
    - functions: GetRandomItem

Mock:
- `map/tasks`:
    - functions: GetTaskByName()
- `worldsettings_overrides`
    - functions: Pre(), Post()

## Global Variables

- strings.lua
    - `STRINGS`
- constants.lua
    - `LEVELTYPE`
    - `LEVELCATEGORY`
    - `SPECIAL_EVENTS`
    - `DEFAULT_LOCATION`

## Global Functions

- util.lua
    - `FunctionOrValue()`
    - `GetTableSize()`
    - `deepcopy()`
    - `IsTableEmpty()`
    - `MergeMapsDeep()`
    - `GetRandomItem()`
    - `table.invert()`
- strict.lua
    - `global()`
- modutil.lua
    - `ModInfoname()`: use `KnownModIndex`
    - `moderror()`: use `ModManager`, `KnownModIndex`, ModInfoname(), global()

## Global Classes

CustomPresetManager, Profile

- map/level
    - `Level`
- mods.lua
    - `ModManager`
- modindex.lua
    - `KnownModIndex`
- playerprofile.lua
    - `PlayerProfile` (Profile)
    - main.lua: `Profile = require("playerprofile")()`
- custompresets.lua
    - `CustomPresets` (CustomPresetManager)
    - gamelogic.lua: `CustomPresetManager = CustomPresets()`
