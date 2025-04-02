# サーバーファイルを置いているディレクトリ
server_dir=/home/yakijake/mcbedrock_sandbox
# バックアップを置いとくディレクトリ
backup_dir=/home/yakijake/mcbedrock_bak/sandbox

if [ ${server_dir: -1} = "/" -o ${backup_dir: -1} = "/" ]; then
  echo 'server_dir,backup_dirの一番後ろには"/"をつけないでください'
  exit
fi

cd $server_dir

#現在のバージョンを取得
current_ver=$(echo "stop" |./bedrock_server | grep Version | cut -d " " -f 5)
echo -e "\e[32m現在バージョン:" $current_ver "\e[m \n"

#webスクレイピングで最新バージョンのDLリンクを取得(chromeのUA使用)
latest_link=$(curl -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36" https://www.minecraft.net/en-us/download/server/bedrock | grep https://www.minecraft.net/bedrockdedicatedserver/bin-linux/ | cut -d '"' -f 2)

#バージョン部分のみを抽出
latest_ver=$(echo $latest_link | cut -d "-" -f 4 | sed -e "s/.zip//")

echo -e "\e[32m最新バージョン:" $latest_ver "\e[m"
echo "URL:" $latest_link


echo "mcbedrock/bedrock_serverが停止しているか確認してください"
read -p "アップデート作業を続行しますか?(y/n)" key
case "$key" in
        [yY]) echo "続行" ;;
        *) echo "中断"; exit ;;
esac

echo "/mcbedrockをコピーしています..."
cp -r $server_dir $backup_dir/$current_ver
echo "コピー完了"

echo "最新バージョンのzipをダウンロードしています..."
# -nv:進捗を表示せず結果だけ表示
wget -nv $latest_link -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"

echo "zipを解凍しています..."
unzip -o -q bedrock-server-$latest_ver.zip

echo "permissions.json,server.properties,allowlist.jsonをバックアップからコピーしています..."
cd $backup_dir/$current_ver
cp permissions.json server.properties allowlist.json $server_dir
echo "tarでアーカイブしています"
cd $backup_dir
tar -zcf $current_ver.tar $current_ver --remove-files
echo "作業完了"
