# ubuntu serverの日本語化,タイムゾーン変更
apt -y install language-pack-ja-base language-pack-ja
localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
timedatectl set-timezone Asia/Tokyo
