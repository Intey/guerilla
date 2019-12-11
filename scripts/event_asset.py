import yaml

with open('./assets/events.yaml') as f:
    payload = f.read()
    data = yaml.load(payload)
    print(data)
