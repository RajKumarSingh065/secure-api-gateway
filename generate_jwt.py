import jwt
import datetime

payload = {
    "iss": "CouldBeASecret",
    "user": "test-user",
    "exp": int((datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=24)).timestamp())
}
secret = "8b2e5c1a9d4f7e3b6c0a2d8f5b1e7c3a8b2e5c1a9d4f7e3b6c0a2d8f5b1e7c3a"
token = jwt.encode(payload, secret, algorithm="HS256")
print(token)