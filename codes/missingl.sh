#!/bin/bash

EDP="sweep.edp"
LOG="runSweep.log"
SLEEP_BETWEEN=5   # segundos de pausa entre runs (0 = sin pausa)

echo "Inicio sweep: $(date)" | tee -a $LOG

run() {
    local wr=$1 rhoS=$2 vin=$3
    echo "--- wr=$wr rhoS=$rhoS vin=$vin ---" | tee -a $LOG
    FreeFem++ -v 0 $EDP -wr "$wr" -rhoS "$rhoS" -vin "$vin" 2>&1 | tee -a $LOG
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "WARNING: fallo wr=$wr rhoS=$rhoS vin=$vin" | tee -a $LOG
    fi
    [ "$SLEEP_BETWEEN" -gt 0 ] && sleep "$SLEEP_BETWEEN"
}

run_full() {
    local wr=$1 rhoS=$2 vin=$3 mulabel=$4 l=$5
    echo "--- wr=$wr rhoS=$rhoS vin=$vin mulabel=$mulabel l=$l ---" | tee -a $LOG
    FreeFem++ -v 0 $EDP -wr "$wr" -rhoS "$rhoS" -vin "$vin" -mulabel "$mulabel" -l "$l" 2>&1 | tee -a $LOG
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "WARNING: fallo wr=$wr rhoS=$rhoS vin=$vin mulabel=$mulabel l=$l" | tee -a $LOG
    fi
    [ "$SLEEP_BETWEEN" -gt 0 ] && sleep "$SLEEP_BETWEEN"
}


# ============================================================
# L SENSITIVITY TEST (rhoS=1380, mulabel=1)
# vin in {0.023, 0.143}, wr in {0.033, 0.066}, l = 0.3 ... 0.8
# Se omiten combinaciones con l=0.6 ya cubiertas por el sweep principal
# ============================================================
for vin in 0.111; do
    for wr in 0.066; do
        for l in 0.3 0.4 0.5 0.6 0.7 0.8; do
            if [ "$l" == "0.6" ]; then
                if [ "$wr" == "0.066" ] && [ "$vin" == "0.143" ]; then continue; fi
                if [ "$wr" == "0.033" ] && [ "$vin" == "0.143" ]; then continue; fi
                if [ "$wr" == "0.066" ] && [ "$vin" == "0.023" ]; then continue; fi
            fi
            run_full $wr 1380 $vin 1 $l
        done
    done
done


echo "Sweep completo: $(date)" | tee -a $LOG