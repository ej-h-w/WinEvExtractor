# WinEvExtractor
- WinEvExtractor  
Windowsイベントログのメッセージを対象に検索を行いログデータを抽出するpowershellスクリプト
です。
- 検索ログの対象期間  
スクリプト実行日から過去７日です。
- 抽出結果  
スクリプトファイルがある階層に、txtファイルで出力します。

# 導入

- リリースより、ファイル一式をダウンロードしてください(Source code (zip)など)  
https://github.com/ej-h-w/WinEvExtractor/releases/

- ダウンロードした圧縮ファイルを展開します  

展開後の例
```
WinEvExtractor
        README.md
        script.ini
        winevent.ps1
```


# 使い方

## 1. `script.ini` で、検索単語を設定する  
- `SearchMessage=<ReplaceSomeWord>` の `<ReplaceSomeWord>` を検索したい文字列に置き換えてください。  
 例）`SomeException` が含まれているログを抽出したい場合、  
`SearchMessage=SomeException` として保存します。


## 2. `winevent.ps1` スクリプトを実行する
1. `winevent.ps1`ファイルを右クリックします。  
2. 右クリックメニューから、 `PowerShell で実行` を押下し実行してください。  
3. 実行後、`winevent.ps1` と同じ階層に抽出したログのtxtファイルが出力されます。  
※実行時にスクリプトエラーが発生した場合は、別途エラー概要txtファイルも出力されます。  
※抽出ログtxtファイルが空の場合は、検索したい文字列に該当がない場合です。適宜script.iniを変更し、お試しください。

