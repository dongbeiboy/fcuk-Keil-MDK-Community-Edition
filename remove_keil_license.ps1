
# 获取脚本路径
$scriptPath = $MyInvocation.MyCommand.Path

# 检查是否以管理员权限运行
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "权限不足，正在尝试以管理员权限重新运行脚本..." -ForegroundColor Yellow

    # 使用 ProcessStartInfo 来等待并获取退出代码
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-File `"$scriptPath`""
    $psi.Verb = "runas"
    $psi.WorkingDirectory = Split-Path $scriptPath

    try {
        $proc = [System.Diagnostics.Process]::Start($psi)
        $proc.WaitForExit()
        # 将子进程的退出码传递出去
        exit $proc.ExitCode
    } catch {
        Write-Host "以管理员权限重启失败或被取消：$($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 提权成功提示
Write-Host "已获得管理员权限！" -ForegroundColor Green
Write-Host "按回车键继续..."
do {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} while ($key.VirtualKeyCode -ne 13)

# 获取当前用户名
$username = $env:USERNAME
$armlmPath = "C:\Users\$username\.armlm"

# 第一屏：显示欢迎信息
Clear-Host
Write-Host "移除社区版keilMDK许可证" -ForegroundColor Cyan
Write-Host "by_DB-oy" -ForegroundColor Yellow
Write-Host ""
Write-Host "请选择操作："
Write-Host "1. 进入下一步"
Write-Host "2. 退出"
Write-Host ""

# 获取用户输入
$choice = Read-Host "请输入选项 (1 或 2)"

# 处理用户选择
if ($choice -eq "1") {
    # 进入下一步，搜索.armlm文件夹
    Write-Host ""
    Write-Host "正在搜索许可证文件夹..." -ForegroundColor Yellow

    # 检查文件夹是否存在
    if (Test-Path $armlmPath) {
        Write-Host "已找到许可证文件夹: $armlmPath" -ForegroundColor Green
        $step = Read-Host "输入1继续，按其他任意键退出"
        if ($step -ne "1") { exit }

        Write-Host ""
        Write-Host "正在打开文件夹..." -ForegroundColor Yellow

        # 打开文件夹
        Start-Process explorer.exe -ArgumentList $armlmPath

        # 检查内部是否包含必要的子文件夹
        $requiredFolders = @("cache", "locks", "logs", "store", "usage")
        $foundFolders = @()

        foreach ($folder in $requiredFolders) {
            $folderPath = Join-Path $armlmPath $folder
            if (Test-Path $folderPath) {
                $foundFolders += $folder
            }
        }

        Write-Host ""
        Write-Host "检查文件夹内容..." -ForegroundColor Yellow

        # 如果找到所有必需的文件夹
        if ($foundFolders.Count -eq $requiredFolders.Count) {
            Write-Host "已找到所有必需的文件夹: $($foundFolders -join ', ')" -ForegroundColor Green
            $step = Read-Host "输入1删除许可证文件夹内容，其他任意键退出"
            if ($step -ne "1") { exit }

            Write-Host ""
            Write-Host "正在删除许可证文件夹内容..." -ForegroundColor Yellow

            # 尝试删除.armlm文件夹内的内容
            try {
                Remove-Item -Path "$armlmPath\*" -Recurse -Force
                Write-Host ""
                Write-Host "已清理社区版许可证" -ForegroundColor Green
                Write-Host "记得开一下注册机手动破解啊" -ForegroundColor Green
            }
            catch {
                Write-Host ""
                Write-Host "不兑，有问题，我怎么删不掉他" -ForegroundColor Red
            }
        }
        else {
            Write-Host "已找到的文件夹: $($foundFolders -join ', ')" -ForegroundColor Yellow
            Write-Host "好像少了点什么，但删掉也是有用的" -ForegroundColor Yellow
            $step = Read-Host "输入1清空.armlm文件夹，按其他任意键退出"
            if ($step -eq "1") {
                Write-Host ""
                Write-Host "正在删除许可证文件夹内容..." -ForegroundColor Yellow

                # 尝试删除.armlm文件夹内的内容
                try {
                    Remove-Item -Path "$armlmPath\*" -Recurse -Force
                    Write-Host ""
                    Write-Host "已清理社区版许可证" -ForegroundColor Green
                    Write-Host "记得开一下注册机手动破解啊" -ForegroundColor Green
                }
                catch {
                    Write-Host ""
                    Write-Host "不兑，有问题，我怎么删不掉他" -ForegroundColor Red
                }
            }
        }
    }
    else {
        Write-Host "未找到许可证文件夹: $armlmPath" -ForegroundColor Red
        Write-Host "没找着文件，好像出错了" -ForegroundColor Red
    }
}
elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "程序已退出。" -ForegroundColor Yellow
    exit
}
else {
    Write-Host ""
    Write-Host "无效的选项，程序将退出。" -ForegroundColor Red
}

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
