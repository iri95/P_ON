FROM python:3.9

COPY ./app /app
WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 7070

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7070"]