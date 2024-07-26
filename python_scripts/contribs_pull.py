import requests, json

json_file = json.loads(requests.get("https://api.github.com/repos/RavioliMavioli/malware-slayer/contributors").text)
logins = ""
for login in json_file:
    logins += login['login'] + "\n"

f = open("etc/contributors.txt", "w")
f.write(logins)
f.close()

print("Succesfully written new contributors:")
print(logins)
