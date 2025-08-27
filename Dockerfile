# ===== Runtime Stage =====
FROM node:20-alpine
WORKDIR /app

# package.json / yarn.lock を先にコピーして依存解決
COPY package*.json yarn.lock ./

# 本番依存のみインストール（軽量化のため devDependencies は含めない）
RUN yarn install --frozen-lockfile --production --ignore-scripts --prefer-offline && yarn cache clean

# GitHub Actions 側でビルド済みの dist をコピー
COPY dist ./dist

# 静的アセット等があればここで追加コピー
# COPY public ./public

# 非rootユーザーで実行（セキュリティ強化）
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
USER nodejs

# アプリが待ち受けるポート番号
EXPOSE 3000

# アプリを起動
CMD ["node", "dist/index.js"]
