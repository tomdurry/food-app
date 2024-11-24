FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.12

WORKDIR /var/task

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY create_database.py .

CMD ["create_database.lambda_handler"]
