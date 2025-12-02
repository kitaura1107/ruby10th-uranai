require 'json'

module Routes
  Result = proc do |req, res|

    # JSON からカードデータを読み込む
    tarot_data = JSON.parse(File.read('./result.json'))
    
    # 完全ランダムで1枚選ぶ
    card_info = tarot_data.sample

    # ランダムで返す
    is_upright = rand > 0.5

    position_name = is_upright ? "正位置（せいいち）" : "逆位置（ぎゃくいち）"
    meaning = is_upright ? card_info["upright"]["meaning"] : card_info["reversed"]["meaning"]
    advice  = is_upright ? card_info["upright"]["advice"]  : card_info["reversed"]["advice"]

    template = ERB.new(File.read("views/result.html.erb"))
    html = template.result(binding)

    res['Content-Type'] = 'text/html'
    res.body = html
  end
end
