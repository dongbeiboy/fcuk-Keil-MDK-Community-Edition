
# ��ȡ�ű�·��
$scriptPath = $MyInvocation.MyCommand.Path

# ����Ƿ��Թ���ԱȨ������
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ȩ�޲��㣬���ڳ����Թ���ԱȨ���������нű�..." -ForegroundColor Yellow

    # ʹ�� ProcessStartInfo ���ȴ�����ȡ�˳�����
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-File `"$scriptPath`""
    $psi.Verb = "runas"
    $psi.WorkingDirectory = Split-Path $scriptPath

    try {
        $proc = [System.Diagnostics.Process]::Start($psi)
        $proc.WaitForExit()
        # ���ӽ��̵��˳��봫�ݳ�ȥ
        exit $proc.ExitCode
    } catch {
        Write-Host "�Թ���ԱȨ������ʧ�ܻ�ȡ����$($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# ��Ȩ�ɹ���ʾ
Write-Host "�ѻ�ù���ԱȨ�ޣ�" -ForegroundColor Green
Write-Host "���س�������..."
do {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} while ($key.VirtualKeyCode -ne 13)

# ��ȡ��ǰ�û���
$username = $env:USERNAME
$armlmPath = "C:\Users\$username\.armlm"

# ��һ������ʾ��ӭ��Ϣ
Clear-Host
Write-Host "�Ƴ�������keilMDK����֤" -ForegroundColor Cyan
Write-Host "by_DB-oy" -ForegroundColor Yellow
Write-Host ""
Write-Host "��ѡ�������"
Write-Host "1. ������һ��"
Write-Host "2. �˳�"
Write-Host ""

# ��ȡ�û�����
$choice = Read-Host "������ѡ�� (1 �� 2)"

# �����û�ѡ��
if ($choice -eq "1") {
    # ������һ��������.armlm�ļ���
    Write-Host ""
    Write-Host "������������֤�ļ���..." -ForegroundColor Yellow

    # ����ļ����Ƿ����
    if (Test-Path $armlmPath) {
        Write-Host "���ҵ�����֤�ļ���: $armlmPath" -ForegroundColor Green
        $step = Read-Host "����1������������������˳�"
        if ($step -ne "1") { exit }

        Write-Host ""
        Write-Host "���ڴ��ļ���..." -ForegroundColor Yellow

        # ���ļ���
        Start-Process explorer.exe -ArgumentList $armlmPath

        # ����ڲ��Ƿ������Ҫ�����ļ���
        $requiredFolders = @("cache", "locks", "logs", "store", "usage")
        $foundFolders = @()

        foreach ($folder in $requiredFolders) {
            $folderPath = Join-Path $armlmPath $folder
            if (Test-Path $folderPath) {
                $foundFolders += $folder
            }
        }

        Write-Host ""
        Write-Host "����ļ�������..." -ForegroundColor Yellow

        # ����ҵ����б�����ļ���
        if ($foundFolders.Count -eq $requiredFolders.Count) {
            Write-Host "���ҵ����б�����ļ���: $($foundFolders -join ', ')" -ForegroundColor Green
            $step = Read-Host "����1ɾ������֤�ļ������ݣ�����������˳�"
            if ($step -ne "1") { exit }

            Write-Host ""
            Write-Host "����ɾ������֤�ļ�������..." -ForegroundColor Yellow

            # ����ɾ��.armlm�ļ����ڵ�����
            try {
                Remove-Item -Path "$armlmPath\*" -Recurse -Force
                Write-Host ""
                Write-Host "����������������֤" -ForegroundColor Green
                Write-Host "�ǵÿ�һ��ע����ֶ��ƽⰡ" -ForegroundColor Green
            }
            catch {
                Write-Host ""
                Write-Host "���ң������⣬����ôɾ������" -ForegroundColor Red
            }
        }
        else {
            Write-Host "���ҵ����ļ���: $($foundFolders -join ', ')" -ForegroundColor Yellow
            Write-Host "�������˵�ʲô����ɾ��Ҳ�����õ�" -ForegroundColor Yellow
            $step = Read-Host "����1���.armlm�ļ��У�������������˳�"
            if ($step -eq "1") {
                Write-Host ""
                Write-Host "����ɾ������֤�ļ�������..." -ForegroundColor Yellow

                # ����ɾ��.armlm�ļ����ڵ�����
                try {
                    Remove-Item -Path "$armlmPath\*" -Recurse -Force
                    Write-Host ""
                    Write-Host "����������������֤" -ForegroundColor Green
                    Write-Host "�ǵÿ�һ��ע����ֶ��ƽⰡ" -ForegroundColor Green
                }
                catch {
                    Write-Host ""
                    Write-Host "���ң������⣬����ôɾ������" -ForegroundColor Red
                }
            }
        }
    }
    else {
        Write-Host "δ�ҵ�����֤�ļ���: $armlmPath" -ForegroundColor Red
        Write-Host "û�����ļ������������" -ForegroundColor Red
    }
}
elseif ($choice -eq "2") {
    Write-Host ""
    Write-Host "�������˳���" -ForegroundColor Yellow
    exit
}
else {
    Write-Host ""
    Write-Host "��Ч��ѡ������˳���" -ForegroundColor Red
}

Write-Host ""
Write-Host "��������˳�..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
