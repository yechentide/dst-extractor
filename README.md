# dst-extractor

[简体中文(Simplified Chinese)](./docs/README.zh-CN.md)
[日本語(Japanese)](./docs/README.ja.md)

## What this repository can do

Those scripts let you extract lua data from DST Dedicated Server files or safe data and convert to JSON.
To run the scripts in this repository, use `lua5.1` or `luajit`.

1. `extract-worldgen-vanilla`: Extract settings used during world generation from **server source code**
2. `extract-mod-config`: Extract basic information and configuration items of a mod from **modinfo.lua**
3. `convert-worldgen-override`: Extract world settings from **worldgenoverride.lua** or **leveldataoverride.lua**
4. `convert-mod-override`: Extract mod settings from **modoverrides.lua**

## ToDo

- [ ] `extract-worldgen-mod`: Extract settings added during world generation by mods (such as `Island Adventures` and `Uncompromising Mode`)

## Usage

### extract-worldgen-vanilla

- `unzip` command is required.
- The default value for `output_dir_path` is `./output/worldgen`.
- `${dst_version}` must be a number. For example `593204`.
    - The version number is stored in `${path_to_dst_server_dir}/version.txt`.
- [Output JSON format](./docs/json-templates/worldgen-vanilla.jsonc)

```bash
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir}
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir} ${output_dir_path}
lua extract-worldgen-vanilla.lua ${dst_version} ${path_to_unzipped_scripts_dir}
lua extract-worldgen-vanilla.lua ${dst_version} ${path_to_unzipped_scripts_dir} ${output_dir_path}

# if the path of scripts.zip is /root/server/data/databundles/scripts.zip
lua extract-worldgen-vanilla.lua /root/server

# output_dir_path/
# ├── ......
# ├── en.forest.master.json
# ├── en.cave.master.json
# ├── en.forest.json
# └── en.cave.json
```

### extract-mod-config

- The default value for `output_dir_path` is `./output/modconfig`.
- The default value for `lang_code` is `en`.
    - You can specify other language codes, but if the mod is not supported, the output will be english, maybe.
- [Output JSON format](./docs/json-templates/mod-config.jsonc)

```bash
lua extract-mod-config.lua ${path_to_target_mod_dir}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path} ${lang_code}
```

### convert-worldgen-override

- The default value for `output_dir_path` is `./output`.
- [Output JSON format](./docs/json-templates/worldgen-override.jsonc)

```bash
lua convert-worldgen-override.lua ${path_to_shard_dir}
lua convert-worldgen-override.lua ${path_to_shard_dir} ${output_dir_path}
```

### convert-mod-override

- The default value for `output_dir_path` is `./output`.
- [Output JSON format](./docs/json-templates/mod-override.jsonc)

```bash
lua convert-mod-override.lua ${path_to_shard_dir}
lua convert-mod-override.lua ${path_to_shard_dir} ${output_dir_path}
```
