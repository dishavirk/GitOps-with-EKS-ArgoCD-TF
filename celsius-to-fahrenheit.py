from flask import Flask
from flask import request

app = Flask(__name__)

@app.route("/")
def index():
    celsius = request.args.get("celsius", "")
    if celsius:
        fahrenheit = fahrenheit_from(celsius)
    else:
        fahrenheit = ""
    return (
        """<form action="" method="get">
                <h1>Celsius temperature: </h1> <input type="text" name="celsius">
                <input type="submit" value="Convert to Fahrenheit">
            </form>"""
        + "<h1>Fahrenheit:</h1> "
        + fahrenheit
    )

def fahrenheit_from(celsius):
    """Convert Celsius to Fahrenheit degrees."""
    try:
        fahrenheit = float(celsius) * 9 / 5 + 32
        fahrenheit = round(fahrenheit, 3)  # Round to three decimal places
        return "<h1>"+str(fahrenheit)+"</h1>"
    except ValueError:
        return "<h1>Invalid input</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
