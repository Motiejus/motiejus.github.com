# lock your screen by whoever
_motiejus() {
    local sleeptime=$((cat $HOME/.motiejus 2>/dev/null || echo -n 0; echo +0.1) | bc)
    echo -n $sleeptime | tee $HOME/.motiejus
}
sleep $(_motiejus)
