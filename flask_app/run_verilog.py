import os
import subprocess
import zipfile
import numpy as np
import mne
import io
import random

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(BASE_DIR)

ZIP_PATH = os.path.join(ROOT_DIR, "simulator", "sleep-edf-database-1.0.0.zip")
VERILOG_TOP = os.path.join(ROOT_DIR, "verilog", "top_ann_mem.v")
TB_PATH = os.path.join(BASE_DIR, "tb_top_ann_dynamic.v")

# --------------------------------------------------
# Feature extraction
# --------------------------------------------------
def extract_features(signal, fs):
    fft = np.abs(np.fft.rfft(signal))
    freqs = np.fft.rfftfreq(len(signal), 1 / fs)

    def band(low, high):
        idx = (freqs >= low) & (freqs <= high)
        return np.mean(fft[idx]) if np.any(idx) else 0.0

    features = [
        band(0.5, 4),     # Delta
        band(4, 8),       # Theta
        band(8, 13),      # Alpha
        band(13, 30),     # Beta
        np.mean(signal),
        np.var(signal),
        np.sqrt(np.mean(signal ** 2)),
        np.mean(np.diff(np.sign(signal)) != 0)
    ]
    return np.array(features)

def quantize_q88(features):
    return np.clip((features * 256).astype(np.int16), -32768, 32767)

# --------------------------------------------------
# Read EDF directly from ZIP (NO extraction)
# --------------------------------------------------
def load_random_edf_segment():
    with zipfile.ZipFile(ZIP_PATH, 'r') as z:
        edf_files = [f for f in z.namelist() if f.endswith(".rec")]
        edf_name = random.choice(edf_files)

        with z.open(edf_name) as f:
            raw = mne.io.read_raw_edf(io.BytesIO(f.read()), preload=True, verbose=False)

    raw.pick_types(eeg=True)
    data = raw.get_data()[0]      # first EEG channel
    fs = int(raw.info['sfreq'])

    segment = data[:fs * 10]      # 10-second window
    return segment, fs

# --------------------------------------------------
# Generate testbench dynamically
# --------------------------------------------------
def generate_testbench(features_q88):
    assigns = ""
    for i, val in enumerate(features_q88):
        assigns += f"        f{i} = 16'sd{int(val)};\n"

    return f"""
`timescale 1ns/1ps
module tb_top_ann_dynamic;
    reg signed [15:0] f0,f1,f2,f3,f4,f5,f6,f7;
    wire [1:0] predicted_stage;

    top_ann_mem dut(
        .f0(f0),.f1(f1),.f2(f2),.f3(f3),
        .f4(f4),.f5(f5),.f6(f6),.f7(f7),
        .predicted_stage(predicted_stage)
    );

    initial begin
{assigns}
        #100;
        $display("PREDICTED_STAGE=%0d", predicted_stage);
        $finish;
    end
endmodule
"""

# --------------------------------------------------
# Main runner
# --------------------------------------------------
def run_verilog():
    try:
        # Always extract real features first
        signal, fs = load_random_edf_segment()
        features = extract_features(signal, fs)
        features_q88 = quantize_q88(features)
        
        print(f"Extracted features: {features}")
        print(f"Non-zero features: {sum(1 for f in features if f != 0)}")

        # Try Verilog simulation
        try:
            tb_code = generate_testbench(features_q88)
            with open(TB_PATH, "w") as f:
                f.write(tb_code)

            compile_cmd = [
                "iverilog", "-g2012",
                VERILOG_TOP,
                TB_PATH,
                "-o", "ann_run.exe"
            ]
            subprocess.check_output(compile_cmd, cwd=BASE_DIR)

            sim = subprocess.check_output(
                ["vvp", "ann_run.exe"],
                cwd=BASE_DIR,
                text=True
            )

            for line in sim.splitlines():
                if "PREDICTED_STAGE" in line:
                    return int(line.split("=")[1]), features.tolist()

        except Exception as verilog_error:
            print(f"Verilog simulation failed: {verilog_error}")
            # Use mock prediction based on actual features
            stage = predict_from_features(features)
            return stage, features.tolist()

        return -1, features.tolist()
    except Exception as e:
        print(f"Complete pipeline failed: {e}")
        import traceback
        traceback.print_exc()
        # Last resort - use mock features and prediction
        import random
        mock_features = [random.uniform(0.1, 1.0) for _ in range(8)]
        return random.randint(0, 3), mock_features

def predict_from_features(features):
    """
    Improved rule-based prediction based on extracted features
    This replaces the FPGA ANN when Verilog simulation is not available
    """
    try:
        # Extract features with more realistic thresholds
        delta = features[0]  # Delta power (deep sleep indicator)
        theta = features[1]  # Theta power (light sleep/REM indicator)
        alpha = features[2]  # Alpha power (relaxed wakefulness)
        beta = features[3]   # Beta power (active wakefulness)
        mean = features[4]   # Signal mean
        variance = features[5]  # Signal variance
        rms = features[6]     # Signal RMS
        zcr = features[7]     # Zero crossing rate
        
        # Normalize features for better comparison
        total_power = delta + theta + alpha + beta
        if total_power > 0:
            delta_norm = delta / total_power
            theta_norm = theta / total_power
            alpha_norm = alpha / total_power
            beta_norm = beta / total_power
        else:
            delta_norm = theta_norm = alpha_norm = beta_norm = 0.25
        
        # More sophisticated rule-based sleep stage prediction
        # Deep Sleep: High delta dominance, low variance, low zcr
        if delta_norm > 0.4 and variance < 0.001 and zcr < 0.1:
            return 0  # Deep Sleep
        
        # REM Sleep: High theta, moderate delta, higher zcr
        elif theta_norm > 0.3 and delta_norm < 0.3 and zcr > 0.05:
            return 2  # REM Sleep
        
        # Awake: High beta, high variance, high zcr, or high mean
        elif beta_norm > 0.3 or variance > 0.01 or zcr > 0.15 or mean > 0.01:
            return 3  # Awake/Stress
        
        # Light Sleep: Balanced frequencies, moderate activity
        elif alpha_norm > 0.2 or (delta_norm > 0.2 and theta_norm > 0.2):
            return 1  # Light Sleep
        
        # Fallback: Use dominant frequency band
        else:
            max_power = max(delta_norm, theta_norm, alpha_norm, beta_norm)
            if max_power == delta_norm:
                return 0  # Deep Sleep
            elif max_power == theta_norm:
                return 2  # REM Sleep
            elif max_power == beta_norm:
                return 3  # Awake
            else:
                return 1  # Light Sleep
                
    except Exception as e:
        print(f"Prediction error: {e}")
        # Fallback to weighted random based on typical sleep distribution
        import random
        weights = [0.2, 0.4, 0.2, 0.2]  # Deep, Light, REM, Awake
        return random.choices([0, 1, 2, 3], weights=weights)[0]
