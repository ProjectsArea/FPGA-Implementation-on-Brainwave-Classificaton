from flask import Flask, jsonify, render_template
from run_verilog import run_verilog

app = Flask(__name__)

# Store the last features globally
last_features = []
feature_names = [
    "Delta Power (0.5-4 Hz)",
    "Theta Power (4-8 Hz)", 
    "Alpha Power (8-13 Hz)",
    "Beta Power (13-30 Hz)",
    "Signal Mean",
    "Signal Variance",
    "Signal RMS",
    "Zero Crossing Rate"
]

@app.route("/")
def landing():
    return render_template("landing.html")

@app.route("/predict")
def predict_page():
    return render_template("predict.html")

@app.route("/simulator")
def simulator():
    return render_template("simulator.html", features=last_features, feature_names=feature_names)

@app.route("/last_features")
def last_features_api():
    return jsonify({"features": last_features, "feature_names": feature_names})

@app.route("/predict", methods=["POST"])
def predict():
    global last_features
    stage, features = run_verilog()
    
    # Store features for simulator page
    last_features = features

    labels = {
        0: "Deep Sleep",
        1: "Light Sleep",
        2: "REM Sleep",
        3: "Awake / Stress"
    }

    return jsonify({
        "stage_id": stage,
        "stage_name": labels.get(stage, "Unknown"),
        "features": features
    })

if __name__ == "__main__":
    app.run(debug=True)
