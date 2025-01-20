# FROM --platform=linux/amd64 public.ecr.aws/lambda/python:3.12

# WORKDIR /var/task

# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # CMD ["recipe_generate.lambda_handler"]

# CMD ["python3", "-m", "awslambdaric", "recipe_generate.lambda_handler"]

FROM public.ecr.aws/lambda/python:3.12

WORKDIR /var/task

COPY . .

RUN pip install --no-cache-dir fastapi pydantic openai mangum

CMD ["recipe_generate.lambda_handler"]