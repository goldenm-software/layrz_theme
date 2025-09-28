"""Decode the json string from environment variable"""

import json
import os
from pathlib import Path

data = json.loads(os.environ["PUB_JSON"])

# Get the current directory
current_dir = os.getcwd()

result = os.path.join(current_dir, "credentials.json")

with open(result, "w", encoding="utf-8") as f:
    f.write(json.dumps(data))

os.system("gcloud auth activate-service-account --key-file=credentials.json")
os.system(
    "gcloud auth print-identity-token --audiences=https://pub.dev | "
    + "dart pub token add https://pub.dev"
)

os.remove("credentials.json")

BASE_DIR = Path(__file__).resolve().parent
VERSION = os.getenv("VERSION", "v0.0.0").replace("v", "")
pubspec_path = BASE_DIR / "pubspec.yaml"

with open(pubspec_path, "r") as f:
    lines = f.readlines()

line_no = None
for i, line in enumerate(lines):
    if "version" in line:
        line_no = i
        break

if line_no is None:
    raise ValueError("Version not found in pubspec.yml")

lines[line_no] = f'version: "{VERSION.strip()}"\n'

with open(pubspec_path, "w") as f:
    f.writelines(lines)
