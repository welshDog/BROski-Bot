# 🤝 Contributing to BROski-Bot

Thanks for wanting to contribute to BROski-Bot! This guide will help you get started. 🐶♾️

## 🐛 Found a Bug?

1. **Search existing issues** - Maybe it's already reported!
2. **Create a new issue** using the [Bug Report template](https://github.com/welshDog/BROski-Bot/issues/new?template=bug_report.md)
3. **Include details**: OS, Python version, steps to reproduce

## 🚀 Want to Add a Feature?

1. **Check existing feature requests** - Avoid duplicates
2. **Create a feature request** using the [Feature Request template](https://github.com/welshDog/BROski-Bot/issues/new?template=feature_request.md)
3. **Wait for feedback** before starting work (prevents wasted effort)

## 💻 Development Setup

### Quick Start

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/BROski-Bot.git
cd BROski-Bot

# Run setup script
chmod +x scripts/setup.sh
./scripts/setup.sh

# Or use Makefile
make install
```

### Manual Setup

```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Install dependencies
poetry install

# Setup .env
cp .env.example .env
# Edit .env and add DISCORD_TOKEN

# Install pre-commit hooks
poetry run pre-commit install
```

## 📦 Making Changes

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Write Code

- Follow the **existing code style**
- Add **docstrings** to functions
- Keep functions **small and focused**
- Use **type hints** where possible

### 3. Format Code

Pre-commit hooks auto-format, but you can manually run:

```bash
make format
# or
poetry run black src/ tests/
poetry run ruff check --fix src/ tests/
```

### 4. Write Tests

Add tests for new features:

```python
# tests/test_your_feature.py
import pytest
from src.cogs.your_feature import YourFeature

@pytest.mark.asyncio
async def test_your_feature():
    # Test logic here
    assert True
```

Run tests:

```bash
make test
# or
poetry run pytest tests/ -v
```

### 5. Commit

```bash
git add .
git commit -m "✨ Add amazing feature"
```

Commit message prefixes:
- `✨` - New feature
- `🐛` - Bug fix
- `📚` - Documentation
- `♻️` - Refactor
- `🧪` - Tests
- `🚀` - Performance improvement

### 6. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then open a Pull Request on GitHub using the [PR template](https://github.com/welshDog/BROski-Bot/compare).

## 📝 Code Style Guide

### Python Style

- **Line length**: 100 characters (enforced by Black)
- **Imports**: Sorted by Ruff (stdlib, third-party, local)
- **Naming**:
  - Functions/variables: `snake_case`
  - Classes: `PascalCase`
  - Constants: `UPPER_SNAKE_CASE`

### Example

```python
from discord.ext import commands
import discord

class MyCog(commands.Cog):
    """Brief description of what this cog does."""

    def __init__(self, bot):
        self.bot = bot

    @commands.hybrid_command(name="mycommand")
    async def my_command(self, ctx, user: discord.Member):
        """
        Command description here.

        Args:
            ctx: Command context
            user: Target user
        """
        await ctx.send(f"Hello {user.mention}!")

async def setup(bot):
    await bot.add_cog(MyCog(bot))
```

## 🧪 Testing Guidelines

- **Every new feature needs tests**
- Use `pytest.mark.asyncio` for async tests
- Mock Discord API calls (don't spam real servers)
- Aim for **80%+ coverage** (check with `make test`)

## 🧠 Neurodivergent-Friendly Practices

BROski-Bot is built **for** neurodivergent developers **by** neurodivergent developers. Please:

- **Keep docs clear and concise** (no walls of text)
- **Use visual cues** (emojis, headings, bullet points)
- **Break complex tasks into steps**
- **Be patient and supportive** in reviews

## 🔍 Review Process

1. **CI checks pass** (tests, linting, Docker build)
2. **Maintainer reviews code**
3. **Feedback addressed** (if any)
4. **PR merged** 🎉
5. **You earn BROski$!** (virtual high-five 🤝)

## 🏆 Recognition

All contributors get:
- Listed in CHANGELOG.md
- Mentioned in release notes
- Virtual BROski$ tokens (for fun)
- Our eternal gratitude! 🙏

## ❓ Questions?

- **Discord**: [Join our server](https://discord.gg/placeholder)
- **GitHub Discussions**: [Ask here](https://github.com/welshDog/BROski-Bot/discussions)
- **Issues**: [Open an issue](https://github.com/welshDog/BROski-Bot/issues/new/choose)

---

**Thanks for contributing to BROski-Bot! You're legendary! 🐶♾️🔥**
