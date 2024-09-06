from fastapi import FastAPI

app=FastAPI()

@app.get("/api2/send/{message}")
async def reverse_message(message: str):
    reversed_message = message[::-1]

    return {
        "original": message,
        "processed": reversed_message
    }