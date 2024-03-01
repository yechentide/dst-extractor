# dst-extractor

## 这个仓库的作用

使用这个仓库，你可以从DST Dedicated Server的文件或者存档里，提取出lua数据并输出为JSON。
执行这里的脚本需要`lua5.1`或者`luajit`。

1. `extract-worldgen-vanilla`: 从**服务端的源码**里提取出世界生成時所使用的设置选项
2. `extract-mod-config`: 从**modinfo.lua**里提取出Modの基本信息以及设置选项
3. `convert-worldgen-override`: 从**worldgenoverride.lua**或者**leveldataoverride.lua**里提取出玩家所设置的世界选项
4. `convert-mod-override`: 从**modoverrides.lua**里提取出玩家所设置的Mod设置选项

## ToDo

- [ ] `extract-worldgen-mod`: 提取出由Mod所添加的创建世界时的选项 (`Island Adventures`，`Uncompromising Mode`等等)

## 用法

### extract-worldgen-vanilla

- 需要用到`unzip`命令。
- `output_dir_path`的默认值为`./output/worldgen`。
- `${dst_version}`必须是数字。例如`593204`。
    - 版本号存储在`${path_to_dst_server_dir}/version.txt`中。
- [输出的JSON结构](./json-templates/worldgen-vanilla.jsonc)

```bash
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir}
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir} ${output_dir_path}
lua extract-worldgen-vanilla.lua ${dst_version} ${path_to_unzipped_scripts_dir}
lua extract-worldgen-vanilla.lua ${dst_version} ${path_to_unzipped_scripts_dir} ${output_dir_path}

# scripts.zip 的路径为 /root/server/data/databundles/scripts.zip 的话
lua extract-worldgen-vanilla.lua /root/server

# output_dir_path/
# ├── ......
# ├── en.forest.master.json
# ├── en.cave.master.json
# ├── en.forest.json
# └── en.cave.json
```

### extract-mod-config

- `output_dir_path`的默认值为`./output/modconfig`。
- 不指定`lang_code`的话默认为`en`。
    - 你也可以指定别的语言码，但如果Mod不支持的话应该会变成英语。
- [输出的JSON结构](./json-templates/mod-config.jsonc)

```bash
lua extract-mod-config.lua ${path_to_target_mod_dir}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path} ${lang_code}
```

### convert-worldgen-override

- `output_dir_path`的默认值为`./output/modconfig`。
- [输出的JSON结构](./json-templates/worldgen-override.jsonc)

```bash
lua convert-worldgen-override.lua ${path_to_shard_dir}
lua convert-worldgen-override.lua ${path_to_shard_dir} ${output_dir_path}
```

### convert-mod-override

- `output_dir_path`的默认值为`./output/modconfig`。
- [输出的JSON结构](./json-templates/mod-override.jsonc)

```bash
lua convert-mod-override.lua ${path_to_shard_dir}
lua convert-mod-override.lua ${path_to_shard_dir} ${output_dir_path}
```
