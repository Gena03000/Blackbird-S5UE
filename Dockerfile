FROM python:3.11-slim

RUN npm install --omit=dev

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

ENV PORT=8000

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]

ENV PORT=5000

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT"]
