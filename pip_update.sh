update=`python3 -m pip list -o | awk 'NR > 2{print $1}'`

list=($update)

for var in ${list[@]}
do
	echo "$var"
	python3 -m pip install -U "$var"
done

echo 終了
echo ${list[@]}
