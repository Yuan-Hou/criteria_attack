#!/bin/bash
# Bash脚本：按给定模型名称依次调用三个任务
# 使用方法: ./run_all_tasks.sh your-model-name

if [ $# -eq 0 ]; then
    echo "错误: 请提供模型名称"
    echo "使用方法: ./run_all_tasks.sh <model_name>"
    exit 1
fi

MODEL_NAME=$1

echo "========================================"
echo "开始运行所有任务，使用模型: $MODEL_NAME"
echo "========================================"

# 任务1：正负面评论分类
echo ""
echo "[1/3] 运行正负面评论分类任务..."
python ./tasks/pos_neg_review/review_classifier.py --model_name $MODEL_NAME
if [ $? -ne 0 ]; then
    echo "错误: 正负面评论分类任务失败"
    exit 1
fi

# 任务2：垃圾邮件检测
echo ""
echo "[2/3] 运行垃圾邮件检测任务..."
python ./tasks/spam_detect/spam_detector.py --model_name $MODEL_NAME
if [ $? -ne 0 ]; then
    echo "错误: 垃圾邮件检测任务失败"
    exit 1
fi

# 任务3：有害评论分类
echo ""
echo "[3/3] 运行有害评论分类任务..."
python ./tasks/toxic_comment/toxic_classifier.py --model_name $MODEL_NAME
if [ $? -ne 0 ]; then
    echo "错误: 有害评论分类任务失败"
    exit 1
fi

echo ""
echo "========================================"
echo "所有任务完成! 模型: $MODEL_NAME"
echo "========================================"
