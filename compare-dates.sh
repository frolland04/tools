date_a="2023-09-04T05:01:41Z"
date_b="2023-09-04T15:01:41Z"

if [[ "$date_a" > "$date_b" ]] ;
then
    echo "a>b"
else
    echo "a<b"
fi
