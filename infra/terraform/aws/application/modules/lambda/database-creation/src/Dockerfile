# ベースイメージの選択
FROM python:3.13

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をインストール
COPY requirements.txt .
RUN pip install -r requirements.txt

# Lambda関数コードをコピー
COPY lambda_function.py .

# Lambdaのエントリポイントを設定
CMD ["lambda_function.lambda_handler"]