module Routes
  Uranai = proc do |req, res|
    base_images = Dir.glob("./img/*").map { |path| File.basename(path) }
    cards = Array.new(18) { base_images.sample }

    template = ERB.new(File.read("views/uranai.html.erb"))
    html = template.result(binding)  # bindingでローカル変数を ERB に渡す

    res['Content-Type'] = 'text/html'
    res.body = html
  end
end
