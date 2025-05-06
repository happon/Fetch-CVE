param(
    [switch]$j
)

# APIキーの設定
$apiKey = 'my_api'

# ヘッダーにAPIキーを追加
$headers = @{
    'apiKey' = $apiKey
}

# 現在のUTC日付を取得
$utcNow = Get-Date -AsUtc

# 日本時間に変換するかどうかを判定
if ($j) {
    # 日本時間に変換
    $startDateTime = $utcNow.Date.AddHours(9)
    $endDateTime = $startDateTime.AddHours(23).AddMinutes(59).AddSeconds(59)
    $startDate = $startDateTime.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
    $endDate = $endDateTime.ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
} else {
    # UTCのまま
    $startDateTime = $utcNow.Date
    $endDateTime = $startDateTime.AddHours(23).AddMinutes(59).AddSeconds(59)
    $startDate = $startDateTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    $endDate = $endDateTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
}

# 現在のユーザーのデスクトップパスを取得
$desktopPath = [Environment]::GetFolderPath("Desktop")

function Fetch-And-Save-CVEData {
    param (
        [string]$url,
        [string]$dateProperty,
        [string]$suffix
    )
    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        if ($null -ne $response -and $response.vulnerabilities.Count -gt 0) {
            $latestVulnerability = $response.vulnerabilities | Sort-Object -Property { $_.cve.$dateProperty } -Descending | Select-Object -First 1
            $latestDate = $latestVulnerability.cve.$dateProperty

            if ($latestDate) {
                $latestDateFormatted = [DateTime]::Parse($latestDate).ToString("yyyy_MM_dd_HH_mm_ss")
                $fileName = "cve_${latestDateFormatted}_$suffix.json"
                $filePath = Join-Path -Path $desktopPath -ChildPath $fileName
                $response | ConvertTo-Json -Depth 100 | Out-File -FilePath $filePath -Encoding utf8
                Write-Output "CVEデータを $filePath に保存しました。"
            } else {
                Write-Warning "CVEデータの最新日付を取得できませんでした。"
            }
        } else {
            Write-Warning "CVEデータの取得に失敗するか、脆弱性が見つかりませんでした。"
        }
    } catch {
        Write-Error "エラーが発生しました: $_"
    }
}

# lastModifiedでフィルタリングしてCVEデータを取得し、保存
$urlModified = "https://services.nvd.nist.gov/rest/json/cves/2.0/?lastModStartDate=$startDate&lastModEndDate=$endDate"
Fetch-And-Save-CVEData -url $urlModified -dateProperty "lastModified" -suffix "modified"

# pubStartDateとpubEndDateでフィルタリングして最近のCVEデータを取得し、保存
$urlRecent = "https://services.nvd.nist.gov/rest/json/cves/2.0/?pubStartDate=$startDate&pubEndDate=$endDate"
Fetch-And-Save-CVEData -url $urlRecent -dateProperty "published" -suffix "recent"
