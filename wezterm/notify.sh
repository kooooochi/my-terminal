#!/bin/bash
# Claude Code 通知スクリプト
# 使い方: notify.sh <type> [message]
#   type: agent-start | agent-stop | task-done | permission | stop

TYPE="${1:-info}"
CUSTOM_MSG="${2:-}"

case "$TYPE" in
  agent-start)
    TITLE="Claude Code"
    SUBTITLE="🤖 Agent 開始"
    MESSAGE="${CUSTOM_MSG:-エージェントが開始しました}"
    SOUND="Pop"
    ;;
  agent-stop)
    TITLE="Claude Code"
    SUBTITLE="✅ Agent 完了"
    MESSAGE="${CUSTOM_MSG:-エージェントが完了しました}"
    SOUND="Glass"
    ;;
  task-done)
    TITLE="Claude Code"
    SUBTITLE="✅ Task 完了"
    MESSAGE="${CUSTOM_MSG:-タスクが完了しました}"
    SOUND="Tink"
    ;;
  permission)
    TITLE="⚠️ Claude Code"
    SUBTITLE="🔔 許可が必要です"
    MESSAGE="${CUSTOM_MSG:-操作の許可を求めています。確認してください}"
    SOUND="Ping"
    ;;
  stop)
    TITLE="Claude Code"
    SUBTITLE="🎉 全作業完了"
    MESSAGE="${CUSTOM_MSG:-全ての作業が完了しました}"
    SOUND="Hero"
    ;;
  *)
    TITLE="Claude Code"
    SUBTITLE="ℹ️ 通知"
    MESSAGE="${CUSTOM_MSG:-$TYPE}"
    SOUND="Bottle"
    ;;
esac

osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" subtitle \"$SUBTITLE\" sound name \"$SOUND\""
