from fastapi import FastAPI, Header

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}
