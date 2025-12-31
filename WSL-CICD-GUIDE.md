# WSL CI/CD 学习指南

本文档将指导你在 WSL（Windows Subsystem for Linux）中学习和实践 CI/CD（持续集成/持续部署）。

## 目录

- [什么是 CI/CD](#什么是-cicd)
- [WSL 环境准备](#wsl-环境准备)
- [本项目 CI/CD 实践](#本项目-cicd-实践)
- [进阶学习](#进阶学习)

## 什么是 CI/CD

**CI (Continuous Integration - 持续集成)**

- 开发人员频繁地将代码集成到主分支
- 每次集成都通过自动化构建和测试来验证
- 尽早发现和解决集成问题

**CD (Continuous Deployment/Delivery - 持续部署/交付)**

- 自动将代码部署到生产环境或准备部署
- 确保代码始终处于可部署状态
- 加快发布周期

## WSL 环境准备

### 1. 检查 WSL 安装

```bash
# 在 PowerShell 中检查 WSL 版本
wsl --version

# 查看已安装的 Linux 发行版
wsl --list --verbose
```

### 2. 进入 WSL 环境

```bash
# 从 Windows 终端进入 WSL
wsl

# 或指定发行版
wsl -d Ubuntu
```

### 3. 更新包管理器

```bash
# 更新 apt 包列表
sudo apt update
sudo apt upgrade -y
```

### 4. 安装必要工具

```bash
# 安装 Node.js 和 npm
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# 验证安装
node --version
npm --version

# 安装 Git（通常已预装）
sudo apt install -y git
git --version

# 安装其他常用工具
sudo apt install -y curl wget vim
```

## 本项目 CI/CD 实践

### 项目结构

```
ci-demo/
├── package.json      # Node.js 项目配置
├── ci.sh            # CI 脚本
├── README.md        # 项目说明
└── WSL-CICD-GUIDE.md  # 本文档
```

### 理解 CI 脚本 (ci.sh)

本项目包含一个简单的 CI 脚本 `ci.sh`，它演示了 CI/CD 的基本流程：

```bash
#!/bin/bash
set -e  # 遇到错误立即退出

echo "== CI START =="

# 步骤 1: 安装依赖
echo "1️⃣ Install dependencies"
npm install

# 步骤 2: 执行构建
echo "2️⃣ Run build"
npm run build

# 步骤 3: 验证构建结果
echo "3️⃣ Check build result"
test -f dist/index.html

echo "== CI SUCCESS ==="
```

### 在 WSL 中运行 CI 脚本

#### 方式 1: 在 WSL 中直接运行

```bash
# 1. 导航到项目目录（WSL 可以访问 Windows 文件系统）
cd /mnt/d/ci-demo

# 2. 确保脚本有执行权限
chmod +x ci.sh

# 3. 运行 CI 脚本
bash ci.sh
```

#### 方式 2: 从 Windows 终端调用

```powershell
# 在 PowerShell 中运行
wsl bash ./ci.sh
```

### 手动执行各个步骤

学习 CI/CD 最好的方式是理解每一步：

```bash
# 进入项目目录
cd /mnt/d/ci-demo

# 步骤 1: 安装依赖
npm install

# 步骤 2: 运行构建
npm run build

# 步骤 3: 检查构建产物
ls -la dist/
cat dist/index.html

# 步骤 4: 清理构建产物（可选）
rm -rf dist/
```

### 理解构建脚本

查看 `package.json` 中的构建脚本：

```json
{
  "scripts": {
    "build": "echo building... && mkdir -p dist && echo build-ok > dist/index.html"
  }
}
```

这个简单的构建脚本：

1. 打印构建消息
2. 创建 `dist` 目录
3. 生成一个简单的 HTML 文件

## 进阶学习

### 1. 添加测试步骤

创建一个测试脚本：

```bash
# 在 package.json 中添加测试脚本
npm pkg set scripts.test="echo Running tests... && echo Tests passed!"

# 运行测试
npm test
```

### 2. 扩展 CI 脚本

修改 `ci.sh` 添加更多步骤：

```bash
#!/bin/bash
set -e

echo "== CI START =="

echo "1️⃣ Install dependencies"
npm install

echo "2️⃣ Run linting"
# npm run lint

echo "3️⃣ Run tests"
npm test

echo "4️⃣ Run build"
npm run build

echo "5️⃣ Check build result"
test -f dist/index.html

echo "== CI SUCCESS ==="
```

### 3. Git Hooks - 本地 CI/CD

使用 Git hooks 在提交代码前自动运行 CI：

```bash
# 创建 pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit CI checks..."
./ci.sh
EOF

# 添加执行权限
chmod +x .git/hooks/pre-commit

# 现在每次 git commit 时都会自动运行 CI
```

### 4. GitHub Actions - 云端 CI/CD

创建 `.github/workflows/ci.yml`：

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install dependencies
        run: npm install

      - name: Run build
        run: npm run build

      - name: Check build result
        run: test -f dist/index.html
```

### 5. 常用 CI/CD 平台

- **GitHub Actions** - 集成在 GitHub 中，免费额度充足
- **GitLab CI/CD** - GitLab 内置，配置灵活
- **Jenkins** - 开源，高度可定制
- **CircleCI** - 云端服务，易于使用
- **Travis CI** - 老牌 CI 服务

## 实践练习

### 练习 1: 基础流程

```bash
# 1. 进入 WSL
wsl

# 2. 导航到项目
cd /mnt/d/ci-demo

# 3. 运行 CI 脚本
./ci.sh

# 4. 检查输出
```

### 练习 2: 模拟失败场景

```bash
# 修改构建脚本，让它失败
npm pkg set scripts.build="exit 1"

# 运行 CI，观察失败情况
./ci.sh

# 修复构建脚本
npm pkg set scripts.build="echo building... && mkdir -p dist && echo build-ok > dist/index.html"
```

### 练习 3: 添加新的检查

```bash
# 在 ci.sh 中添加代码质量检查
# 比如检查是否存在特定文件
echo "4️⃣ Check package.json exists"
test -f package.json
```

## WSL 特定技巧

### 文件系统路径转换

```bash
# Windows 路径: D:\ci-demo
# WSL 路径: /mnt/d/ci-demo

# 将 Windows 路径转换为 WSL 路径
wslpath 'D:\ci-demo'

# 将 WSL 路径转换为 Windows 路径
wslpath -w /mnt/d/ci-demo
```

### 性能优化

```bash
# 建议: 将频繁操作的项目放在 WSL 文件系统中
# WSL 内部路径性能更好
cp -r /mnt/d/ci-demo ~/projects/ci-demo
cd ~/projects/ci-demo
```

### WSL 与 Windows Git 集成

```bash
# 在 WSL 中配置 Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 配置行尾符（处理 Windows/Linux 差异）
git config --global core.autocrlf input
```

## 常见问题

### Q: 权限被拒绝

```bash
# 如果 ci.sh 无法执行
chmod +x ci.sh
```

### Q: 找不到 npm 命令

```bash
# 确保 Node.js 已安装
which npm
node --version

# 如果未安装，重新安装
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

### Q: Windows 和 WSL 之间的路径问题

```bash
# 使用 /mnt/ 前缀访问 Windows 驱动器
cd /mnt/c/Users/YourName/
cd /mnt/d/ci-demo
```

## 学习资源

- [GitHub Actions 官方文档](https://docs.github.com/cn/actions)
- [GitLab CI/CD 文档](https://docs.gitlab.cn/jh/ci/)
- [Jenkins 中文文档](https://www.jenkins.io/zh/)
- [Docker 官方教程](https://docs.docker.com/get-started/)
- [Kubernetes 基础教程](https://kubernetes.io/zh-cn/docs/tutorials/)

## 下一步

1. ✅ 运行本项目的 CI 脚本，理解基本流程
2. 🔧 修改 CI 脚本，添加自己的检查步骤
3. 🧪 创建实际的测试用例
4. 🚀 尝试配置 GitHub Actions
5. 📦 学习 Docker 容器化
6. ☸️ 探索 Kubernetes 编排

## 总结

CI/CD 是现代软件开发的核心实践。通过 WSL，你可以在 Windows 系统上获得完整的 Linux 开发体验，这对于学习和实践 CI/CD 非常有帮助。

记住 CI/CD 的核心原则：

- **自动化** - 减少人工干预
- **快速反馈** - 尽早发现问题
- **持续改进** - 不断优化流程

开始动手实践吧！🚀
