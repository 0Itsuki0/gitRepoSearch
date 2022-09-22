# GitHub Repository Search

  

## 概要

  

本プロジェクトは株式会社ゆめみの課題のベースプロジェクトを元にアプリを作り上げるプロジェクトです。

  

## アプリ仕様

  

本アプリは GitHub のリポジトリーを検索するアプリです。

 
![動作イメージ](README_Images/app.gif)

  

### 環境

- IDE：Xcode 14.0
- Swift：Swift 5.7
- 開発ターゲット：iOS 15.0
- サードパーティーライブラリーの利用：[SwifttyGif](https://github.com/kirualex/SwiftyGif)


### 基本機能

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名と言語）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、最新アップデート日、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示


### 追加機能

1. 入力無効、データ取得失敗等の場合のワーニング機能
2. 結果一覧にスター数1000以上のリポジトリーに星付き
3. フィルタ機能：星あり・無し、言語
4. 並べ替え機能：Star 数、更新日
5. 詳細ページからGitHub上のリポジトリーページに飛ぶ


### その他の主な変更点

1. Repository Managerの作成
Repository関連FunctionのVCからの分離
2. UIのリメイク
3. テストの追加

  
### 追加予定機能

1. Bookmark機能
    Bookmark Repositoryが前回のデータ取得時の後、更新された場合のお知らせ機能
2. ユーザーが星付き基準を設定できる機能
3. 一回のAPIリクエストで結果を全部取得出来ていないかつユーザーがテーブルの下までスクロールした場合の追加リクエスト及びテーブルのリロード機能
  


## 問題点

  
1. テストのカバレッジ：Protocolのカバレッジが0%
2. パフォーマンステスト：インタネット環境依存のため、実行時間が設定したベースラインを大きく上回る場合があり、Failしがち
3. MockとStubが上手く利用出来ていない
4. Xcode 14・IOS 16のアップデート後、NavigationBarのInconsistent configurationに関するワーニング。 [こちらの記事](https://developer.apple.com/forums/thread/714278)と同じ問題。

  
  
## 参考記事

  
- トグルボタン: [Making a simple toggle button with UIButton](https://medium.com/@craiggrummitt/making-a-simple-toggle-button-with-uibutton-e9c69a9deb0b)
- テスト：[iOS Unit Testing and UI Testing Tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial)
- UIテストチートシート：[Xcode UI Testing](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial)
- XCTest: [XCTest](https://developer.apple.com/documentation/xctest#2870839)
- Accessibility Identifiers：[XCUIElementの使い方をざっくりまとめてみた](https://qiita.com/terry-private/items/81c07510d90d5946d0fc)
- GIFの使用：[Animated launch screen using a GIF in iOS](https://www.amerhukic.com/animating-launch-screen-using-gif)
- グラデーションの使用：[Create Gradients in App (UIKit, Swift 5, Xcode 12, 2021) - iOS Development](https://www.youtube.com/watch?v=Qk_H0mlSIQc)
