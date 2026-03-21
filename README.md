# UI
このコードを自分のスクリプトの下に貼り付けるだけで、すぐにタブと機能を追加できます。
-- 1. タブの作成
local MainTab = UI:CreateTab("メイン機能")

-- 2. ボタンの作成 (クリックで実行)
UI:CreateButton(MainTab, "テストボタン", function()
    print("ボタンが押されました！")
end)

-- 3. トグルの作成 (ON/OFF 切り替え)
UI:CreateToggle(MainTab, "オートファーム", function(state)
    if state then
        print("ON: 実行中...")
    else
        print("OFF: 停止中")
    end
end)

📖 各パーツの解説
| パーツ | 書き方 | 用途 |
|---|---|---|
| タブ | local Tab = UI:CreateTab("名前") | 機能を分けるための新しいページを作ります。 |
| ボタン | UI:CreateButton(Tab, "名前", function() ... end) | 1回限りの動作（テレポートやステータス更新など）に使います。 |
| トグル | UI:CreateToggle(Tab, "名前", function(state) ... end) | 継続的な動作（自動攻撃、無限ジャンプなど）のON/OFFに使います。 |
