#!/bin/bash

# iOS App Icon Generator Script
# 使用方法: ./generate_icons.sh your_icon_512x512.png

if [ $# -eq 0 ]; then
    echo "使用方法: $0 <512x512的icon文件>"
    echo "例如: $0 app_icon_512.png"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_DIR="JiaJiaRong-iOS/Assets.xcassets/AppIcon.appiconset"

# 检查输入文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 文件 $INPUT_FILE 不存在"
    exit 1
fi

# 检查是否安装了sips（macOS自带）
if ! command -v sips &> /dev/null; then
    echo "错误: 需要sips命令（macOS自带）"
    exit 1
fi

echo "开始生成iOS App Icons..."

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 生成各种尺寸的icon
echo "生成 icon-20.png (20x20)"
sips -z 20 20 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-20.png" > /dev/null 2>&1

echo "生成 icon-20@2x.png (40x40)"
sips -z 40 40 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-20@2x.png" > /dev/null 2>&1

echo "生成 icon-20@3x.png (60x60)"
sips -z 60 60 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-20@3x.png" > /dev/null 2>&1

echo "生成 icon-29.png (29x29)"
sips -z 29 29 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-29.png" > /dev/null 2>&1

echo "生成 icon-29@2x.png (58x58)"
sips -z 58 58 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-29@2x.png" > /dev/null 2>&1

echo "生成 icon-29@3x.png (87x87)"
sips -z 87 87 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-29@3x.png" > /dev/null 2>&1

echo "生成 icon-40.png (40x40)"
sips -z 40 40 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-40.png" > /dev/null 2>&1

echo "生成 icon-40@2x.png (80x80)"
sips -z 80 80 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-40@2x.png" > /dev/null 2>&1

echo "生成 icon-40@3x.png (120x120)"
sips -z 120 120 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-40@3x.png" > /dev/null 2>&1

echo "生成 icon-60@2x.png (120x120)"
sips -z 120 120 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-60@2x.png" > /dev/null 2>&1

echo "生成 icon-60@3x.png (180x180)"
sips -z 180 180 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-60@3x.png" > /dev/null 2>&1

echo "生成 icon-76.png (76x76)"
sips -z 76 76 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-76.png" > /dev/null 2>&1

echo "生成 icon-76@2x.png (152x152)"
sips -z 152 152 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-76@2x.png" > /dev/null 2>&1

echo "生成 icon-83.5@2x.png (167x167)"
sips -z 167 167 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-83.5@2x.png" > /dev/null 2>&1

echo "生成 icon-1024.png (1024x1024)"
sips -z 1024 1024 "$INPUT_FILE" --out "$OUTPUT_DIR/icon-1024.png" > /dev/null 2>&1

echo ""
echo "🎉 Icon生成完成！"
echo "生成的文件位置: $OUTPUT_DIR"
echo ""
echo "下一步:"
echo "1. 在Xcode中打开项目"
echo "2. 选择Assets.xcassets > AppIcon"
echo "3. 检查所有icon是否正确显示"
echo "4. 重新编译项目" 