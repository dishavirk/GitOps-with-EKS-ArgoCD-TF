from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def index():
    return (
        """<form action="/to_fahrenheit" method="get">
                <h1>Convert Celsius to Fahrenheit:</h1> 
                <input type="text" name="celsius">
                <input type="submit" value="Convert">
            </form>
            <br>
            <form action="/to_celsius" method="get">
                <h1>Convert Fahrenheit to Celsius:</h1> 
                <input type="text" name="fahrenheit">
                <input type="submit" value="Convert">
            </form>"""
    )

@app.route("/to_fahrenheit")
def to_fahrenheit():
    celsius = request.args.get("celsius", "")
    if celsius:
        fahrenheit = fahrenheit_from(celsius)
    else:
        fahrenheit = "<h1>Please enter a value</h1>"
    return fahrenheit

@app.route("/to_celsius")
def to_celsius():
    fahrenheit = request.args.get("fahrenheit", "")
    if fahrenheit:
        celsius = celsius_from(fahrenheit)
    else:
        celsius = "<h1>Please enter a value</h1>"
    return celsius

def fahrenheit_from(celsius):
    try:
        fahrenheit = float(celsius) * 9 / 5 + 32
        fahrenheit = round(fahrenheit, 3)  # Round to three decimal places
        return f"<h1>{fahrenheit}°F</h1>"
    except ValueError:
        return "<h1>Invalid input</h1>"

def celsius_from(fahrenheit):
    try:
        celsius = (float(fahrenheit) - 32) * 5 / 9
        celsius = round(celsius, 3)  # Round to three decimal places
        return f"<h1>{celsius}°C</h1>"
    except ValueError:
        return "<h1>Invalid input</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
