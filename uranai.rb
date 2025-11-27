require 'webrick'

server = WEBrick::HTTPServer.new(Port: 8000)

server.mount '/img', WEBrick::HTTPServlet::FileHandler, './img'

server.mount '/result.json', WEBrick::HTTPServlet::FileHandler, './result.json'

server.mount_proc '/' do |req, res|

  base_images = Dir.glob("./img/*").map { |path| File.basename(path) }

  cards = Array.new(12) { base_images.sample }

  res['Content-Type'] = 'text/html'
  res.body = <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Rubyビジネス推進協会10thタロット占い</title>
      <style>
        body {
          font-family: "Segoe UI", sans-serif;
          background: #faf5ff;
          margin: 0;
          padding: 20px;
          text-align: center;
          color: #333;
        }

        h1 {
          font-size: 28px;
          color: #aa0000;
          margin-bottom: 10px;
        }

        p {
          font-size: 16px;
          margin: 8px 0;
        }

        div {
          margin-top: 25px;
        }

        /* カード画像 */
        .card {
          width: 110px;
          height: auto;
          margin: 10px;
          cursor: pointer;
          border-radius: 8px;
          transition: transform 0.2s, box-shadow 0.2s;
          box-shadow: 0 3px 8px rgba(0,0,0,0.15);
        }

        /* ホバー時のアニメーション */
        .card:hover {
          transform: scale(1.1) rotate(-2deg);
          box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }

        /* カード一覧の配置 */
        div {
          display: flex;
          justify-content: center;
          flex-wrap: wrap;
        }

        /* 全体の余白調整 */
        body > * {
          max-width: 800px;
          margin-left: auto;
          margin-right: auto;
        }
      </style>
    </head>
    <body>
      <h1>タロット占いへようこそ！</h1>
      <P>ここでは今日のあなたの運勢を占います😀。。。。</p>
      <p>好きなカードの選択をしてね！</p>
       
      <div>
        #{cards.map.with_index { |img, i|
          "<img class='card' data-index='#{i}' src='./img/#{img}' width='100'>"
        }.join(" ")}
      </div>

      <script>
        let tarotData = [];

        fetch("/result.json")
          .then(res => res.json())
          .then(data => {
            tarotData = data;
          });

        const cards = document.querySelectorAll('.card');

        cards.forEach(card => {
          card.addEventListener('click', () => {
            const index = parseInt(card.dataset.index, 10);

            const isUpright = Math.random() > 0.5;

            const cardInfo = tarotData[index % tarotData.length];

            const positionName = isUpright ? "正位置（せいいち）" : "逆位置（ぎゃくいち）";
            const meaning = isUpright ? cardInfo.upright.meaning : cardInfo.reversed.meaning;
            const advice = isUpright ? cardInfo.upright.advice : cardInfo.reversed.advice;

            const message = `
            ★ 選ばれたカード ★
            --------------------------------
            【${cardInfo.name}]
            位置：${positionName}

            ◆ 意味
            ${meaning}

            ◆ アドバイス
            ${advice}
                  `;

            alert(message);
          });
        });
      </script>
    </body>
    </html>
  HTML
end

trap('INT') { server.shutdown }

puts "http://localhost:8000"
server.start
