#!bin/sh

# check if repo exists
restic snapshots &>/dev/null

# init repo
if [ $? -gt 0 ]; then
  restic init
fi

if [ -n "$RESTIC_JSON" ]; then
  RESTIC_ARGS="--json $RESTIC_ARGS"
fi

if [ -n "$RESTIC_TAG" ]; then
  RESTIC_ARGS="--tag $RESTIC_TAG $RESTIC_ARGS"
fi

if [ -n "$RESTIC_HOST" ]; then
  RESTIC_ARGS="--host $RESTIC_HOST $RESTIC_ARGS"
fi

# backup all directories/files in backup folder
for b in $(ls -d /backup/*); do
  
  OUT=$(restic backup $b $RESTIC_ARGS 2>&1)
  
  # execute error script if restic backup failed
  if [ -n "$REPORT_SCRIPT" ]; then
    $REPORT_SCRIPT "$OUT" $REPORT_SCRIPT_AFTER
  fi

  # log
  echo "$OUT"
done

# execute restic forget
if [ -n "$RESTIC_FORGET_ARGS" ]; then
  
  if [ -n "$RESTIC_JSON" ]; then
    RESTIC_FORGET_ARGS="--json $RESTIC_FORGET_ARGS"
  fi

  OUT=$(restic forget $RESTIC_FORGET_ARGS 2>&1)
  
  if [ -n "$REPORT_SCRIPT" ]; then
    $REPORT_SCRIPT "$OUT" $REPORT_SCRIPT_AFTER
  fi

  # log
  echo "$OUT"
fi