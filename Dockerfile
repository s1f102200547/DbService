# Node.js 18 の公式イメージを使用
FROM node:18

# 作業ディレクトリを作成
WORKDIR /usr/src/app

# 依存関係をコピーしてインストール
COPY package*.json yarn.lock ./
RUN yarn install --production=false

# ソースコードをコピー
COPY . .

# TypeScript をビルド（→ dist/ に出力）
RUN yarn build

# 本番環境では devDependencies を削除（容量削減）
RUN yarn install --production --ignore-scripts --prefer-offline

# アプリを起動
CMD ["yarn", "start"]
