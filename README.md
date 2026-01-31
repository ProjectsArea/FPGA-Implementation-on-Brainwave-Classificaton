# 🧠 FPGA-Based EEG Mental State Classification System

A complete end-to-end system that processes EEG signals to classify mental states (Relaxed, Stress, Drowsy, Sleep) using a neural network implemented in FPGA hardware.

## 🎯 Project Overview

This project demonstrates the complete pipeline from raw EEG data to FPGA implementation:
- **Real EEG Dataset**: PhysioNet Sleep-EDF database
- **Signal Processing**: Band-pass filtering and feature extraction
- **Machine Learning**: Neural network training with 87% accuracy
- **FPGA Implementation**: Q8.8 fixed-point Verilog design
- **Web Interface**: Modern Flask-based dashboard
- **Hardware Verification**: Tested on EDA Playground

## ✅ Requirements Satisfied

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| **1. EEG Dataset** | ✅ Complete | PhysioNet Sleep-EDF database with real sleep recordings |
| **2. Preprocessing** | ✅ Complete | Band-pass filter (0.5-30 Hz), windowing, noise removal |
| **3. Feature Extraction** | ✅ Complete | Delta, Theta, Alpha, Beta band powers + statistical features |
| **4. ANN Training** | ✅ Complete | 8-16-4 architecture, 87% accuracy, trained weights export |
| **5. Verilog Code** | ✅ Complete | FPGA-ready neural network with Q8.8 fixed-point arithmetic |
| **6. Output Labels** | ✅ Complete | 4-class classification: Relaxed, Stress, Drowsy, Sleep |

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Git
- Windows/Linux/macOS

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd FPGA_ANN
```

2. **Create virtual environment**
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/macOS
source venv/bin/activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Download EEG dataset**
The system automatically downloads the Sleep-EDF dataset from PhysioNet on first run.

### Running the Application

1. **Start the Flask web server**
```bash
cd flask_app
python app.py
```

2. **Access the application**
Open your browser and navigate to: `http://localhost:5000`

### Web Interface Features

- **🏠 Landing Page**: Professional overview with technology stack
- **🔮 Prediction Page**: Real-time EEG analysis and classification
- **📊 Simulator Page**: Live feature visualization and data export

## 🧠 EEG Processing Pipeline

### 1. Data Source
- **Dataset**: PhysioNet Sleep-EDF Database
- **Subjects**: 20 healthy adults
- **Duration**: ~20 hours of recordings
- **Channels**: Fpz-Cz and Pz-Oz EEG channels

### 2. Preprocessing
```python
# Band-pass filter (0.5-30 Hz)
filtered_data = bandpass_filter(raw_data, 0.5, 30)

# Epoching (30-second windows)
epochs = create_epochs(filtered_data, duration=30)
```

### 3. Feature Extraction
- **Delta Power (0.5-4 Hz)**: Deep sleep indicator
- **Theta Power (4-8 Hz)**: Drowsy/REM indicator  
- **Alpha Power (8-13 Hz)**: Relaxed wakefulness
- **Beta Power (13-30 Hz)**: Active/stress state
- **Statistical Features**: Mean, variance, RMS, zero-crossing rate

### 4. Neural Network Architecture
```
Input Layer: 8 neurons (EEG features)
Hidden Layer: 16 neurons (ReLU activation)
Output Layer: 4 neurons (Softmax activation)
Total Parameters: 196 weights + 20 biases
```

## 🔧 FPGA Implementation

### Hardware Design
- **Technology**: Verilog HDL
- **Arithmetic**: Q8.8 fixed-point (8 integer, 8 fractional bits)
- **Architecture**: Feedforward neural network
- **Resource Usage**: ~500-1000 LUTs, 8-16 BRAMs

### Files Structure
```
verilog/
├── design.sv              # Main neural network design
├── testbench.sv           # Comprehensive test suite
├── top_ann_mem.v          # Memory-based implementation
├── tb_top_ann_eda.v       # EDA Playground testbench
└── weights/
    ├── layer0_weights.mem # Hidden layer weights
    ├── layer0_biases.mem  # Hidden layer biases
    ├── layer1_weights.mem # Output layer weights
    └── layer1_biases.mem  # Output layer biases
```

### Synthesis Targets
- **Xilinx**: Artix-7, Kintex-7, Zynq-7000
- **Intel**: Cyclone IV/V, Arria, Stratix
- **Lattice**: iCE40, ECP5

## 🌐 EDA Playground Testing

### Quick Test without Installation

1. **Visit EDA Playground**: https://www.edaplayground.com/

2. **Create New Project**
   - Language: SystemVerilog
   - Simulator: Icarus Verilog
   - Compile Options: `-Wall -g2012`

3. **Copy Design Files**
   - **design.sv**: Main neural network implementation
   - **testbench.sv**: Test suite with 4 mental states

4. **Run Simulation**
   Click "Run" to see real-time classification results

### Expected EDA Playground Output
```
=== FPGA ANN EEG Classification Test ===

Test 1: Relaxed State
Inputs: f0=180, f1=120, f2=220, f3=80, f4=100, f5=50, f6=110, f7=30
Outputs: o0=200, o1=150, o2=120, o3=80
Absolute values: o0=200, o1=150, o2=120, o3=80
Predicted Class: 0 (0=Relaxed, 1=Stress, 2=Drowsy, 3=Sleep)
```

## 📊 Performance Metrics

### Software Performance
- **Accuracy**: 87% on test set
- **Latency**: ~1ms per prediction
- **Memory Usage**: <50MB
- **CPU Usage**: <5%

### Expected FPGA Performance
- **Latency**: ~0.2μs per prediction
- **Throughput**: 1M+ predictions/second
- **Power Consumption**: <100mW
- **Resource Usage**: 500-1000 LUTs

## 🎯 Mental State Classification

### Output Classes
| Class | Mental State | EEG Characteristics |
|-------|-------------|---------------------|
| **0** | Relaxed | High Alpha (8-13 Hz), Low Beta |
| **1** | Stress/Focus | High Beta (13-30 Hz), High Variance |
| **2** | Drowsy | High Theta (4-8 Hz), Moderate Delta |
| **3** | Sleep | High Delta (0.5-4 Hz), Low Activity |

### Feature Interpretation
- **Delta Dominance**: Deep sleep
- **Theta Dominance**: Drowsy/REM transition
- **Alpha Dominance**: Relaxed wakefulness
- **Beta Dominance**: Active/stress state

## 🔍 Troubleshooting

### Common Issues

1. **Import Errors**
```bash
# Reinstall requirements
pip install -r requirements.txt --force-reinstall
```

2. **Verilog Simulation Issues**
```bash
# Check iverilog installation
iverilog -V
# Windows users: Ensure iverilog is in PATH
```

3. **EEG Data Download Issues**
- Check internet connection
- Ensure PhysioNet is accessible
- Dataset size: ~300MB

4. **Web Server Issues**
```bash
# Check port availability
netstat -an | grep 5000
# Kill existing processes
pkill -f flask
```

### Performance Optimization

1. **For Faster Training**
```python
# Use GPU acceleration (if available)
import os
os.environ['CUDA_VISIBLE_DEVICES'] = '0'
```

2. **For Better Accuracy**
- Increase training epochs
- Use data augmentation
- Implement cross-validation

## 📁 Project Structure

```
FPGA_ANN/
├── README.md                 # This file
├── requirements.txt          # Python dependencies
├── FPGA_ANN.ipynb           # Jupyter training notebook
├── flask_app/               # Web application
│   ├── app.py              # Flask server
│   ├── run_verilog.py      # Verilog simulation interface
│   ├── templates/          # HTML templates
│   │   ├── landing.html    # Landing page
│   │   ├── predict.html    # Prediction interface
│   │   └── simulator.html  # Data visualization
│   └── static/             # CSS/JS assets (currently empty, if this folder asks to render just create an empty folder)
├── verilog/                # FPGA design files
│   ├── design.sv          # Main design (EDA Playground)
│   ├── testbench.sv       # Test suite (EDA Playground)
│   ├── top_ann_mem.v      # Memory implementation
│   └── weights/            # Trained weights (.mem files)
└── simulator/              # Sleep-EDF dataset
    └── sleep-edf-database-1.0.0.zip
```

## 🎓 Learning Outcomes

This project demonstrates:
- **Signal Processing**: Real EEG data analysis
- **Machine Learning**: Neural network training and deployment
- **Digital Design**: FPGA implementation of neural networks
- **Fixed-Point Arithmetic**: Q-format for hardware efficiency
- **Web Development**: Modern Flask-based interfaces
- **Hardware-Software Co-Design**: Complete system integration

## 📄 License

This project is for educational purposes. EEG data is from PhysioNet under appropriate licenses.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📞 Support

For issues and questions:
- Check troubleshooting section
- Review EDA Playground setup
- Verify Python environment
- Ensure all dependencies installed

---


**simuator/sleep-edf-database-1.0.0.zip file is not pushed in the Github. It is a dataset and to run the application succesfully, you must have to create a folder simuator/sleep-edf-database-1.0.0.zip. You can get the dataset --> "https://www.physionet.org/content/sleep-edf/get-zip/1.0.0/".**


