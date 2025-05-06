以下は、PowerShell スクリプト `Fetch-CVE.ps1` 用の `README.md` の例です。このスクリプトは、NVD（National Vulnerability Database）から CVE データを取得し、JSON 形式で保存するものです。引数として `-j` を指定すると、日本時間に変換して処理を行います。

---

# Fetch-CVE.ps1

`Fetch-CVE.ps1` は、NVD（National Vulnerability Database）から CVE（Common Vulnerabilities and Exposures）データを取得し、JSON 形式で保存する PowerShell スクリプトです。引数として `-j` を指定すると、日本時間（JST）に変換して処理を行います。

## 機能

* NVD API を使用して、指定した期間の CVE データを取得します。
* 取得したデータを JSON 形式で保存します。
* 引数 `-j` を指定すると、日本時間（JST）に変換して処理を行います。

## 使用方法

### 前提条件

* PowerShell 5.1 以降がインストールされていること。
* インターネット接続があること。
* NVD API キーを取得し、スクリプト内の `$apiKey` 変数に設定すること。

### スクリプトの実行

1. スクリプトを任意のディレクトリに保存します（例：`C:\Scripts\Fetch-CVE.ps1`）。
2. PowerShell を開き、スクリプトが保存されているディレクトリに移動します。

#### UTC 時間で実行する場合（デフォルト）

```powershell
.\Fetch-CVE.ps1
```

#### 日本時間に変換して実行する場合

```powershell
.\Fetch-CVE.ps1 -j
```

## 出力

スクリプトを実行すると、取得した CVE データが JSON 形式で保存されます。ファイル名には、最新の CVE の `lastModified` または `published` 日付が含まれます。

例：

* `cve_2025_05_06_08_00_00_modified.json`
* `cve_2025_05_05_12_00_00_recent.json`

保存先は、現在のユーザーのデスクトップです。

## 注意事項

* NVD API の利用には、API キーが必要です。[NVD API Key Request](https://nvd.nist.gov/developers/request-an-api-key) から取得してください。
* スクリプト内の `$apiKey` 変数に、取得した API キーを設定してください。

## ライセンス

このスクリプトは MIT ライセンスの下で提供されています。

---

この `README.md` をプロジェクトのルートディレクトリに配置することで、GitHub 上でプロジェクトの概要や使用方法を明確に伝えることができます。必要に応じて、プロジェクトの目的や詳細な使用例、貢献方法などを追加してください。
