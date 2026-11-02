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

# ── rhoS=1030, wr=0.044 ───────────────────────────────────────────────────────
for vin in 0.012 0.018 0.023 0.029 0.034 0.039 0.044 0.050 0.056 0.061 0.067 0.073 0.078 0.083 0.088 0.094 0.099 0.105 0.111 0.116 0.122 0.127 0.132 0.138 0.143 0.148 0.154 0.159; do
    run 0.044 1030 $vin
done

# ── rhoS=1030, wr=0.066 ───────────────────────────────────────────────────────
for vin in 0.012 0.018 0.023 0.029 0.034 0.039 0.044 0.050 0.056 0.061 0.067 0.073 0.078 0.083 0.088 0.094 0.099 0.105 0.111 0.116 0.122 0.127 0.132 0.138 0.143 0.148 0.154 0.159; do
    run 0.066 1030 $vin
done

# ── rhoS=1030, wr=0.033 ───────────────────────────────────────────────────────
for vin in 0.012 0.018 0.023 0.029 0.034 0.039 0.044 0.050 0.056 0.061 0.067 0.073 0.078 0.083 0.088 0.094 0.099 0.105 0.111 0.116 0.122 0.127 0.132 0.138 0.143 0.148 0.154 0.159; do
    run 0.033 1030 $vin
done

# ============================================================
# L SENSITIVITY TEST (rhoS=1380, mulabel=1)
# ============================================================
for vin in 0.023 0.078; do
    for wr in 0.033 0.066; do
        for l in 0.4 0.5 0.6 0.7 0.8; do
            if [ "$l" == "0.6" ]; then
                if [ "$wr" == "0.066" ] && [ "$vin" == "0.143" ]; then continue; fi
                if [ "$wr" == "0.033" ] && [ "$vin" == "0.143" ]; then continue; fi
                if [ "$wr" == "0.066" ] && [ "$vin" == "0.023" ]; then continue; fi
            fi
            run_full $wr 1380 $vin 1 $l
        done
    done
done

# ============================================================
# MU SENSITIVITY TEST (rhoS=1380, wr=0.066)
# ============================================================
for vin in 0.023 0.078 0.143; do
    for mulabel in 1 5 20 40 70 100; do
        if [ "$mulabel" == "1" ]; then continue; fi
        run_full 0.066 1380 $vin $mulabel 0.6
    done
done

echo "Sweep completo: $(date)" | tee -a $LOG