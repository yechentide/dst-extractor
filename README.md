# dst-worldgen

## Usage

This script can extract the configurations used in `worldgenoverride.lua` from DST server files and output them as JSON files.  
Based on the combination of world type (forest/cave) and whether it's the main world or not, four JSON files will be generated for each language supported by the server.  
To execute the script, `unzip` and `lua` (or `luajit`) are required.

```bash
git clone https://github.com/PNCommand/dst-worldgen.git
cd dst-worldgen
chmod u+x ./main.sh

# ./main.sh "/{path_to_dst_server_dir}/data/databundles/scripts.zip" "path_to_output_folder"
./main.sh /root/server/data/databundles/scripts.zip /tmp/output

# path_to_output_folder/
#     en.forest.master.json
#     en.forest.json
#     en.cave.master.json
#     en.cave.json
```

## 用法

这个脚本可以从DST服务端文件里面提取出`worldgenoverride.lua`里所用到的配置, 并输出为JSON文件。  
根据世界类型(forest/cave), 以及是否为主世界的组合，将会为服务端支持的所有语言各生成4个JSON文件。  
执行脚本需要`unzip`和`lua` (或者`luajit`)。

```bash
git clone https://github.com/PNCommand/dst-worldgen.git
cd dst-worldgen
chmod u+x ./main.sh

# ./main.sh "/{到DST服务端文件夹的路径}/data/databundles/scripts.zip" "输出文件夹的路径"
./main.sh /root/server/data/databundles/scripts.zip /tmp/output

# 输出文件夹的路径/
#     zh-CN.forest.master.json
#     zh-CN.forest.json
#     zh-CN.cave.master.json
#     zh-CN.cave.json
```

## 使い方

このスクリプトはDSTサーバーファイルから`worldgenoverride.lua`で使用される設定を抽出し、JSONファイルとして出力することができます。  
ワールドのタイプ（forest/cave）とメインワールドかどうかの組み合わせに基づいて、サーバーがサポートするすべての言語で、それぞれ4つのJSONファイルが生成されます。  
スクリプトを実行するには`unzip`と`lua` (または`luajit`) が必要です。

```bash
git clone https://github.com/PNCommand/dst-worldgen.git
cd dst-worldgen
chmod u+x ./main.sh

# ./main.sh "/{DSTサーバディレクトリへのパス}/data/databundles/scripts.zip" "出力フォルダへのパス"
./main.sh /root/server/data/databundles/scripts.zip /tmp/output

# 出力フォルダへのパス/
#     ja.forest.master.json
#     ja.forest.json
#     ja.cave.master.json
#     ja.cave.json
```
