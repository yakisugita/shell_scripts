# サーバーファイルを置いているディレクトリ
server_dir=/home/yakijake/mcbedrock_teriyaki
# バックアップを置いとくディレクトリ
backup_dir=/home/yakijake/mcbedrock_bak/teriyaki

if [ ${server_dir: -1} = "/" -o ${backup_dir: -1} = "/" ]; then
  echo 'server_dir,backup_dirの一番後ろには"/"をつけないでください'
  exit
fi

cd $server_dir

#現在のバージョンを取得
current_ver=$(echo "stop" |./bedrock_server | grep Version | cut -d " " -f 5)
echo -e "\e[32m現在バージョン:" $current_ver "\e[m \n"

#webスクレイピングで最新バージョンのDLリンクを取得(chromeのUA使用)
latest_link=$(curl -s -H "User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6.5; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; MDDS; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" https://www.minecraft.net/en-us/download/server/bedrock | grep https://minecraft.azureedge.net/bin-linux/ | cut -d '"' -f 2)

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
wget -nv $latest_link

echo "zipを解凍しています..."
unzip -o -q bedrock-server-$latest_ver.zip

echo "permissions.json,server.properties,allowlist.jsonをバックアップからコピーしています..."
cd $backup_dir/$current_ver
cp permissions.json server.properties allowlist.json $server_dir
echo "tarでアーカイブしています"
cd $backup_dir
tar -c -f $current_ver.tar $current_ver --remove-files
echo "作業完了"
