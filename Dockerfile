FROM node:20-alpine

WORKDIR /app

# パッケージファイルをコピー
COPY package*.json yarn.lock ./


# 依存関係をインストール（devDependencies含む）
RUN yarn install --frozen-lockfile


# アプリケーションコードをコピー
COPY . .

# TypeScriptをビルド
RUN yarn build

# 本番依存だけ残す
RUN yarn install --frozen-lockfile --production --ignore-scripts --prefer-offline && yarn cache clean;

# 非rootユーザーを作成
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# ファイルの所有権を変更
RUN chown -R nodejs:nodejs /app
USER nodejs

# ポートを公開
EXPOSE 3000

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# アプリケーションを起動
CMD ["node", "dist/index.js"]