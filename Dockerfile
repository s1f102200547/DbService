# ====== Build stage ======
FROM node:20-alpine AS builder
WORKDIR /app

# 依存解決のために先にマニフェストだけコピー
COPY package*.json yarn.lock ./
RUN yarn install --frozen-lockfile

# ソースをコピーして TypeScript ビルド
COPY . .
RUN yarn build

# ====== Runtime stage ======
FROM node:20-alpine AS runtime
WORKDIR /app

# ヘルスチェック用
RUN apk add --no-cache curl

# 本番依存のみインストール（軽量化）
COPY package*.json yarn.lock ./
RUN yarn install --frozen-lockfile --production --ignore-scripts --prefer-offline && yarn cache clean

# ビルド成果物のみコピー
COPY --from=builder /app/dist ./dist

# 必要に応じて静的アセット等があれば追加でコピー
# COPY --from=builder /app/public ./public

# 非rootユーザーで実行
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

# ポート
EXPOSE 3000

# ヘルスチェック（/health を実装しておく）
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# アプリ起動
CMD ["node", "dist/index.js"]
