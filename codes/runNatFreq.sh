#!/bin/bash

EDP="natFreq.edp"
LOG="runNatFreq.log"
SLEEP_BETWEEN=5   # segundos de pausa entre runs (0 = sin pausa)

echo "Inicio natFreq: $(date)" | tee -a $LOG

run() {
    local wr=$1 rhoS=$2 displacement=$3
    echo "--- wr=$wr rhoS=$rhoS displacement=$displacement ---" | tee -a $LOG
    FreeFem++ -v 0 $EDP -wr "$wr" -rhoS "$rhoS" -displacement "$displacement" 2>&1 | tee -a $LOG
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "WARNING: fallo wr=$wr rhoS=$rhoS displacement=$displacement" | tee -a $LOG
    fi
    [ "$SLEEP_BETWEEN" -gt 0 ] && sleep "$SLEEP_BETWEEN"
}

# ── rhoS=1030, wr=0.033 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.033 1030 $displacement
done

# ── rhoS=1030, wr=0.044 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.044 1030 $displacement
done

# ── rhoS=1030, wr=0.066 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.066 1030 $displacement
done

# ── rhoS=1380, wr=0.033 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.033 1380 $displacement
done

# ── rhoS=1380, wr=0.044 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.044 1380 $displacement
done

# ── rhoS=1380, wr=0.066 ───────────────────────────────────────────────────────
for displacement in 0.1 0.15 0.2 0.25; do
    run 0.066 1380 $displacement
done

echo "natFreq completo: $(date)" | tee -a $LOG