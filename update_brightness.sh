display=$(xrandr | grep " connected" | cut -f1 -d " ")
delta=$1
current=$(xrandr --verbose | grep -i brightness | cut -f2 -d " " | head -n1)
added=$(echo "$delta + $current" | bc -l)

greater_than_1=$(echo "$added > 1" | bc -l)
smaller_than_0=$(echo "$added < 0" | bc -l)

if [ "$greater_than_1" -eq "1" ] 
then
    added="1"
elif [ "$smaller_than_0" -eq "1" ] 
then
    added="0"
fi

xrandr --output $display --brightness $added

percentage=$(echo "$added * 100" | bc -l)
notify-send "Brightness $percentage%"
