""" Decode the json string from environment variable """
import os
import json

data = json.loads(os.environ['PUB_JSON'])

# Get the current directory
current_dir = os.getcwd()

result = os.path.join(current_dir, 'credentials.json')

with open(result, 'w', encoding='utf-8') as f:
    f.write(json.dumps(data))

print(result)
