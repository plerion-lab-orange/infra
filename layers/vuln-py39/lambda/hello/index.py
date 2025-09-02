import os, json
import yaml, jinja2, requests, urllib3

def handler(event, context):
    print("Vuln lib versions", {
        "PyYAML": getattr(yaml, "__version__", None),
        "Jinja2": getattr(jinja2, "__version__", None),
        "requests": getattr(requests, "__version__", None),
        "urllib3": getattr(urllib3, "__version__", None),
    })
    print("EnvLeakExample", {k: v for k, v in os.environ.items()
           if k.startswith(("LEAKED_", "STRIPE_"))})
    return {"statusCode": 200, "body": json.dumps({"ok": True})}
