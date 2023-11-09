FROM python:3.7

COPY ./app /app
WORKDIR /app

RUN pip install -r requirements.txt

EXPOSE 7070

CMD ["uvicorn", "main:app"]