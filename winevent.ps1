# �����̌����s�v�Ƃ��ăX�N���v�g���s����i���̎��s�v���Z�X�Z�b�V�������݈̂ꎞ�I�Ɍ����s�v�ݒ�ɂȂ�j
Set-ExecutionPolicy -Scope Process -ExecutionPolicy ByPass -Force

# �X�N���v�g�G���[�t�@�C���o�͊֐�
Function OutputException($Subject){
# �X�N���v�g���s�̗�O�o�͂���ꏊ�w��
$OutputErrorFileName=[string]::Format('winevent_{0:yyMMdd}-{1:yyMMdd}_Error_{2}.txt',$StartTime,$EndTime,$Subject)
$OutputErrorFilePath=Join-Path $PSScriptRoot $OutputErrorFileName

# �G���[�擾
$OutputText = "`r`n--SomeException----------------------------"
$OutputText += "`r`n"
$OutputText += $PSItem.InvocationInfo | Format-List *

# �t�@�C���o��
Write-Output $OutputText | Out-File -FilePath $OutputErrorFilePath -Force
}


# script.ini�Ǎ��w��
$Ini=@{}
$IniFileDirPath=$PSScriptRoot
$IniFileName="script.ini"
$IniFilePath=Join-Path $IniFileDirPath $IniFileName

# script.ini�Ǎ����s
Get-Content $IniFilePath | %{ $Ini += ConvertFrom-StringData $_ }


# WinEvent �S��(Message) �Ɋ܂ޕ�����w��
$Message=$Ini.SearchMessage

# �Ώۂ�WinEvent���O�A���ԁi�ߋ��V���ԁj
$LogName=$Ini.LogName
$EndTime=(Get-Date).Date
$StartTime=(Get-Date).Date.AddDays(-7)

# ���o����WinEvent���O���o�͂���ꏊ�w��
# �{�X�N���v�g���s�f�B���N�g���w��
$OutputFileName=[string]::Format('winevent_{0:yyMMdd}-{1:yyMMdd}.txt',$StartTime,$EndTime)
$OutputFilePath=Join-Path $PSScriptRoot $OutputFileName

$OutputText = "None"
try{
# ���O���o���o�̓R�}���h���s
$OutputText = Get-WinEvent -FilterHashTable @{
LogName=$LogName
StartTime=$StartTime
} |
Where-Object -Property Message -Match $Message |
Format-Table -AutoSize -Wrap

Write-Output $OutputText | Out-File -FilePath $OutputFilePath -Force
}
catch{
# �X�N���v�g��O�t�@�C���o��
OutputException "ext"
}
