#ifndef CONFIG_PAGE_H
#define CONFIG_PAGE_H

const char configPage[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Aquaware Setup</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 0; padding: 20px; background-color: #061626; color: #5277F5; }
        .input-container { position: relative; width: 80%; margin: 10px auto; }
        input { width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #5277F5; background: white; color: #061626; border-radius: 5px; outline: none; font-size: 16px; }
        button { padding: 10px 20px; margin-top: 15px; background: #5277F5; color: white; border: none; cursor: pointer; border-radius: 5px; font-size: 16px; }
    </style>
</head>
<body>
    <h2>Aquaware Configuration</h2>
    <form action="/save" method="POST">
        <div class="input-container"><input type="text" name="ssid" placeholder="WiFi Name" required></div>
        <div class="input-container"><input type="password" name="password" placeholder="WiFi Password" required></div>
        <div class="input-container"><input type="text" name="apikey" placeholder="API Key" required></div>
        <div class="input-container"><input type="text" name="envid" placeholder="Environment ID" required></div>
        <button type="submit">Save</button>
    </form>
</body>
</html>
)rawliteral";

#endif // CONFIG_PAGE_H
