### APP1
This service functions as a RESTful API that receives a user-provided message, sends this message to App2, and then returns both the original and the processed message.

- Endpoint: `/get/send/{message}`
- Functionality: Receives a message from the user, forwards this message to App2, and returns the original and processed message as received from App2.
- Technology: Python with FastAPI.
- Expected Response: `{ "original": "infra", "processed": "arfni" }` when the endpoint `/get/send/infra` is called.