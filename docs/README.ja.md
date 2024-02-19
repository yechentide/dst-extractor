# dst-extractor

## このリポジトリでできること

このリポジトリを使えば、DST Dedicated Serverのファイル、またはセーフデータからluaデータを抽出してJSONに変換できる。
スクリプトを実行するには、`lua5.1`または`luajit`を使ってください。

1. `extract-worldgen-vanilla`: **サーバのソースコード**から、世界生成時に使われる設定を抽出する
2. `extract-mod-config`: **modinfo.lua**から、Modの基本情報や設定項目を抽出する
3. `convert-worldgen-override`: **worldgenoverride.lua**または**leveldataoverride.lua**から、プレイヤーが設定したワールド設定を抽出する
4. `convert-mod-override`: **modoverrides.lua**から、プレイヤーが設定したMod設定を抽出する

## ToDo

- [ ] `extract-worldgen-mod`: Modによってワールド生成時に追加される設定を抽出する (`Island Adventures`や`Uncompromising Mode`など)

## 使い方

### extract-worldgen-vanilla

- `unzip`コマンドが必要です。
- `output_dir_path`のデフォルト値は`./output/worldgen`です。
- [出力JSONのフォーマット](./json-templates/worldgen-vanilla.jsonc)

```bash
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir}
lua extract-worldgen-vanilla.lua ${path_to_dst_server_dir} ${output_dir_path}

# scripts.zip のパスが /root/server/data/databundles/scripts.zip の場合
lua extract-worldgen-vanilla.lua /root/server

# output_dir_path/
# ├── ......
# ├── en.forest.master.json
# ├── en.cave.master.json
# ├── en.forest.json
# └── en.cave.json
```

### extract-mod-config

- `output_dir_path`のデフォルト値は`./output/modconfig`です。
- `lang_code`が指定されていない場合は`en`になります。
    - 他の言語コードを指定してもいいですが、Modがサポートしていない場合には英語になるはずです。
- [出力JSONのフォーマット](./json-templates/mod-config.jsonc)

```bash
lua extract-mod-config.lua ${path_to_target_mod_dir}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path}
lua extract-mod-config.lua ${path_to_target_mod_dir} ${output_dir_path} ${lang_code}
```

### convert-worldgen-override

- `output_dir_path`のデフォルト値は`./output/modconfig`です。
- [出力JSONのフォーマット](./json-templates/worldgen-override.jsonc)

```bash
lua convert-worldgen-override.lua ${path_to_shard_dir}
lua convert-worldgen-override.lua ${path_to_shard_dir} ${output_dir_path}
```

### convert-mod-override

- `output_dir_path`のデフォルト値は`./output/modconfig`です。
- [出力JSONのフォーマット](./json-templates/mod-override.jsonc)

```bash
lua convert-mod-override.lua ${path_to_shard_dir}
lua convert-mod-override.lua ${path_to_shard_dir} ${output_dir_path}
```
