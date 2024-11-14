FROM python:3.13

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY create_database.py .

CMD ["create_database.lambda_handler"]
