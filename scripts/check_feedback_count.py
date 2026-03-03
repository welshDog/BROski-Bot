#!/usr/bin/env python3
"""Check number of feedback entries for retraining threshold"""
import json
from pathlib import Path

feedback_file = Path("data/training/feedback.json")

if not feedback_file.exists():
    print(0)
    exit(0)

with open(feedback_file) as f:
    feedback = json.load(f)

print(len(feedback))
