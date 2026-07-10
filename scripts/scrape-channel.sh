#!/bin/bash
# scrape-channel.sh — 用yt-dlp扒频道公开数据
# 用法: ./scrape-channel.sh <频道URL> [输出目录]

set -e

CHANNEL_URL="${1:?用法: $0 <频道URL> [输出目录]}"
OUTPUT_DIR="${2:-./output}"

mkdir -p "$OUTPUT_DIR"

# 生成文件名
CHANNEL_NAME=$(echo "$CHANNEL_URL" | sed 's/.*@//' | sed 's/.*\///' | sed 's/?.*//')
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="$OUTPUT_DIR/${CHANNEL_NAME}_${TIMESTAMP}.json"

echo "📊 正在扒取频道数据: $CHANNEL_URL"
echo "📁 输出文件: $OUTPUT_FILE"

# 扒取最近30条视频的公开数据
yt-dlp \
  --dump-json \
  --playlist-items 1:30 \
  --no-download \
  --no-warnings \
  "$CHANNEL_URL" | \
  jq -s '{
    channel: .[0].uploader // .[0].channel // "未知",
    channel_id: .[0].channel_id // "未知",
    scraped_at: now | todate,
    video_count: length,
    videos: [.[] | {
      video_id: .id,
      title: .title,
      views: .view_count,
      likes: .like_count,
      comments: .comment_count,
      duration: .duration,
      uploaded: .upload_date,
      thumbnail: .thumbnail,
      description: .description[:200],
      tags: .tags
    }]
  }' > "$OUTPUT_FILE"

echo "✅ 完成！"
echo "   频道: $(jq -r '.channel' "$OUTPUT_FILE")"
echo "   视频数: $(jq -r '.video_count' "$OUTPUT_FILE")"
echo "   文件: $OUTPUT_FILE"
echo ""
echo "📋 数据字段:"
echo "   - video_id, title, views, likes, comments"
echo "   - duration, uploaded, thumbnail, description, tags"
echo ""
echo "🔄 下一步: 将此文件内容粘贴给AI，即可进行C档诊断"
