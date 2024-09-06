import os
from fastapi import FastAPI
import httpx

app = FastAPI()

APP2_URL = os.getenv("APP2_URL","http://app2:80/api2/send/")

@app.get("/get/send/{message}")
async def forward_message(message: str):
    try:
        async with httpx.AsyncClient() as client:
            response_from_app2 = await client.get(APP2_URL + message)
            processed_message = response_from_app2.json()

        return {"original": processed_message["original"],
                "processed": processed_message["processed"]
                }
    except httpx.RequestError as e:
        return {"error": f"An error occured while sending request to App2: {str(e)}"}