#!/bin/bash
mkdir -p dist
cat > dist/index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CI/CD Demo 🚀</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .container {
      max-width: 800px;
      text-align: center;
    }
    h1 { 
      font-size: 4em; 
      margin-bottom: 0.5em;
      animation: fadeInDown 1s;
    }
    .badges {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 15px;
      margin: 30px 0;
    }
    .badge {
      background: rgba(255,255,255,0.2);
      padding: 15px 30px;
      border-radius: 25px;
      backdrop-filter: blur(10px);
      animation: fadeInUp 1s;
      font-size: 1.1em;
    }
    .time {
      margin-top: 50px;
      font-size: 1.2em;
      opacity: 0.9;
    }
    .success { color: #4ade80; font-weight: bold; }
    @keyframes fadeInDown {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🚀 CI/CD Demo</h1>
    <p style="font-size: 1.3em; opacity: 0.9;">持续集成 · 自动部署 · GitHub Actions</p>
    
    <div class="badges">
      <div class="badge">✅ 构建成功</div>
      <div class="badge">📦 自动部署</div>
      <div class="badge">🎉 GitHub Pages</div>
      <div class="badge">⚡ Actions 驱动</div>
    </div>
    
    <div class="time">
      <p>构建时间: <span class="success">$(date '+%Y-%m-%d %H:%M:%S')</span></p>
      <p style="margin-top: 10px;">提交: <span class="success">$(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')</span></p>
    </div>
  </div>
</body>
</html>
EOF

echo "✅ Build completed! Output: dist/index.html"
