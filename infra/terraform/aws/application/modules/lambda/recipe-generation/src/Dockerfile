FROM public.ecr.aws/lambda/python:3.12

WORKDIR /var/task

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY recipe_generate.py .

CMD ["recipe_generate.lambda_handler"]



# FROM --platform=linux/arm64 public.ecr.aws/lambda/python:3.12

# WORKDIR /var/task

# COPY . .

# RUN pip install --no-cache-dir fastapi pydantic openai mangum

# CMD ["recipe_generate.lambda_handler"]