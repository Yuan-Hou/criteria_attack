# PowerShell脚本：按给定模型名称依次调用三个任务
# 使用方法: .\run_all_tasks.ps1 -ModelName "your-model-name"

param(
    [Parameter(Mandatory=$true)]
    [string]$ModelName
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "开始运行所有任务，使用模型: $ModelName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 任务1：正负面评论分类
Write-Host "`n[1/3] 运行正负面评论分类任务..." -ForegroundColor Green
python .\tasks\pos_neg_review\review_classifier.py --model_name $ModelName
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 正负面评论分类任务失败" -ForegroundColor Red
    exit 1
}

# 任务2：垃圾邮件检测
Write-Host "`n[2/3] 运行垃圾邮件检测任务..." -ForegroundColor Green
python .\tasks\spam_detect\spam_detector.py --model_name $ModelName
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 垃圾邮件检测任务失败" -ForegroundColor Red
    exit 1
}

# 任务3：有害评论分类
Write-Host "`n[3/3] 运行有害评论分类任务..." -ForegroundColor Green
python .\tasks\toxic_comment\toxic_classifier.py --model_name $ModelName
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 有害评论分类任务失败" -ForegroundColor Red
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "所有任务完成! 模型: $ModelName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
