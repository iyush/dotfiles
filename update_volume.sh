delta=$1
current_volume="$(\
pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
)"

# LC_NUMERIC to avoid stupid comma as decimal delimiter 
sum=$(LC_NUMERIC=en_US.UTF-8 awk "BEGIN {print $delta + $current_volume}")

greater_than_100=$(echo "$sum > 100" | bc -l)

if [ $greater_than_100 -eq "1" ] 
then
    exit
fi

pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $delta
