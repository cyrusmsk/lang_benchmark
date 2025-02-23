import time
import base64
import hashlib

salt = "o328TeiMlyvfohWn8WuRwA"
password = "testc2usertestc2user"
start_time = time.time()
key = base64.b64encode(
    hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(),600000, dklen=32)).decode()
print(f"Hash: {key}\nDuration: {time.time() - start_time}s\n")
