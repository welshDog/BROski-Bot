# 🧠 Self-Learning Agent System

BROski-Bot improves over time by learning from user feedback and interactions.

## 💡 How It Works

### 1. Feedback Collection

Users rate bot responses with `/feedback 1-5`:

```
User: /daily
Bot: 🎉 Daily reward claimed! +50 BROski$
User: /feedback 5 "Fast and clear!"
```

### 2. Data Storage

Feedback saved to `data/training/feedback.json`:

```json
{
  "timestamp": "2026-03-03T12:00:00Z",
  "user_id": "123456789",
  "rating": 5,
  "comment": "Fast and clear!",
  "bot_response": "🎉 Daily reward claimed! +50 BROski$",
  "user_message": "/daily"
}
```

### 3. Auto-Retraining

When 100+ feedback entries collected, training pipeline triggers automatically (GitHub Actions).

### 4. Model Update

New model deployed via CI/CD (blue-green deployment to avoid downtime).

---

## 🚀 Training Pipeline

### Automated (GitHub Actions)

Triggers on:
- **Manual dispatch** (workflow_dispatch)
- **Scheduled weekly** (Sundays at midnight UTC)
- **100+ new feedback entries** (auto-trigger)

**Workflow**: `.github/workflows/self-learning.yml`

```yaml
name: Self-Learning Agent Retraining

on:
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  retrain:
    steps:
    - Load feedback data
    - Preprocess (filter low-quality)
    - Train model
    - Evaluate metrics
    - Deploy if improved
```

---

## 💻 Manual Training

### 1. Collect Feedback Data

```bash
poetry run python scripts/export_feedback.py
```

Exports `data/training/feedback.json`.

### 2. Train Model

```bash
poetry run python scripts/train_agent.py --epochs 10 --batch-size 32
```

**Options**:
- `--epochs`: Number of training epochs (default: 10)
- `--batch-size`: Training batch size (default: 32)

### 3. Evaluate Performance

```bash
poetry run python scripts/evaluate_model.py
```

**Metrics**:
- Accuracy
- F1 Score
- Avg response time
- User satisfaction score

### 4. Deploy New Model

```bash
poetry run python scripts/deploy_model.py
```

Only deploys if metrics improved over previous version.

---

## 🎯 Feedback Quality

### High-Quality Feedback (Used for Training)

- ⭐⭐⭐⭐⭐ (5 stars) - Excellent
- ⭐⭐⭐⭐ (4 stars) - Good
- ⭐⭐⭐ (3 stars) - Okay

### Low-Quality Feedback (Filtered Out)

- ⭐⭐ (2 stars) or lower - Too vague for training
- No comment + low rating - Not actionable

---

## 💰 Reward System

Users earn **10 BROski$** for each feedback submission.

**Rate Limiting**: 1 feedback per minute (prevents spam).

---

## 🔒 Privacy

- **User IDs**: Hashed before training (anonymized)
- **PII**: Automatically redacted (names, emails, phone numbers)
- **Opt-out**: Available via `/feedback opt-out`

**Data Retention**: Feedback older than 1 year is auto-deleted.

---

## 📈 Metrics Dashboard

View training metrics at:
- **Grafana**: `http://localhost:3001` (if running locally)
- **GitHub Actions**: View workflow logs

**Tracked Metrics**:
- Total feedback entries
- Avg rating (trending)
- Model accuracy over time
- Retraining frequency

---

## 🔧 Technical Details

### Model Architecture

- **Base Model**: GPT-2 (fine-tuned) or Llama 2
- **Framework**: Hugging Face Transformers
- **Training**: LoRA (Low-Rank Adaptation) for efficiency

### Training Hardware

- **Local**: CPU (slow, 30+ min per epoch)
- **GitHub Actions**: CPU (free tier)
- **Recommended**: GPU (NVIDIA T4 or better) for production

### Model Storage

- **Location**: `data/models/`
- **Format**: `.pkl` (scikit-learn) or `.pt` (PyTorch)
- **Versioning**: Timestamped filenames (`model_20260303_120000.pt`)

---

## ❓ FAQ

### Q: How often does the bot retrain?

**A**: Weekly (automated) or when 100+ new feedback entries collected.

### Q: Can I see what the bot learned?

**A**: Yes! Check `data/training/feedback.json` (local) or view metrics in Grafana.

### Q: Does my feedback really matter?

**A**: Absolutely! Every rating helps improve response quality. You're literally training an AI! 🧠🔥

### Q: What if I give bad feedback by mistake?

**A**: No worries! Low ratings are filtered out during preprocessing, and the model averages many inputs.

---

**Help the bot get smarter! Use `/feedback` after every interaction. 🐶♾️**
