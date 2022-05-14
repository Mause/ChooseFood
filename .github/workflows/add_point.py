import json
from pathlib import Path

openapi = Path("lib/swagger/openapi.json")

with openapi.open() as fh:
    data = json.load(fh)

data["definitions"]["Point"] = {
    "type": "object",
    "properties": {
        "type": {"type": "string", "enum": ["Point"]},
        "coordinates": {
            "type": "array",
            "maxLength": 2,
            "minLength": 2,
            "items": {"type": "number"},
        },
    },
}
data["definitions"]["session"]["properties"]["point"] = {"$ref": "#/definitions/Point"}

with openapi.open("w") as fh:
    json.dump(data, fh, indent=2)
    fh.write('\n')
