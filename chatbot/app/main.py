from fastapi import FastAPI, Header

app = FastAPI()


@app.get("/chatbot")
async def root():
    return {"message": "Hello World"}
