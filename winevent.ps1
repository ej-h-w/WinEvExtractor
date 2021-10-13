# 署名の検査不要としてスクリプト実行する（この実行プロセスセッション時のみ一時的に検査不要設定になる）
Set-ExecutionPolicy -Scope Process -ExecutionPolicy ByPass -Force

# スクリプトエラーファイル出力関数
Function OutputException($Subject){
# スクリプト実行の例外出力する場所指定
$OutputErrorFileName=[string]::Format('winevent_{0:yyMMdd}-{1:yyMMdd}_Error_{2}.txt',$StartTime,$EndTime,$Subject)
$OutputErrorFilePath=Join-Path $PSScriptRoot $OutputErrorFileName

# エラー取得
$OutputText = "`r`n--SomeException----------------------------"
$OutputText += "`r`n"
$OutputText += $PSItem.InvocationInfo | Format-List *

# ファイル出力
Write-Output $OutputText | Out-File -FilePath $OutputErrorFilePath -Force
}


# script.ini読込指定
$Ini=@{}
$IniFileDirPath=$PSScriptRoot
$IniFileName="script.ini"
$IniFilePath=Join-Path $IniFileDirPath $IniFileName

# script.ini読込実行
Get-Content $IniFilePath | %{ $Ini += ConvertFrom-StringData $_ }


# WinEvent 全般(Message) に含む文字列指定
$Message=$Ini.SearchMessage

# 対象のWinEventログ、期間（過去７日間）
$LogName=$Ini.LogName
$EndTime=(Get-Date).Date
$StartTime=(Get-Date).Date.AddDays(-7)

# 抽出したWinEventログを出力する場所指定
# 本スクリプト実行ディレクトリ指定
$OutputFileName=[string]::Format('winevent_{0:yyMMdd}-{1:yyMMdd}.txt',$StartTime,$EndTime)
$OutputFilePath=Join-Path $PSScriptRoot $OutputFileName

$OutputText = "None"
try{
# ログ抽出＆出力コマンド実行
$OutputText = Get-WinEvent -FilterHashTable @{
LogName=$LogName
StartTime=$StartTime
} |
Where-Object -Property Message -Match $Message |
Format-Table -AutoSize -Wrap

Write-Output $OutputText | Out-File -FilePath $OutputFilePath -Force
}
catch{
# スクリプト例外ファイル出力
OutputException "ext"
}
