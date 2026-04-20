import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

bind         = "0.0.0.0:5051"
workers      = 1        # must be 1 — session state lives in memory
threads      = 4
worker_class = "gthread"