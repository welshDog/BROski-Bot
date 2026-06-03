# Contributing to BROski Bot

First off, thanks for thinking about contributing! This project is built BY neurodivergent minds, FOR everyone. Your perspective matters. 🧠✨

## Code of Conduct

Please review `CODE_OF_CONDUCT.md` before participating. We're committed to providing a welcoming, harassment-free experience for everyone.

## Ways to Contribute

### 🐛 Report Bugs
Found a bug? Great catch!

1. Check if it's already reported in [Issues](https://github.com/welshDog/BROski-Bot/issues)
2. Use the **Bug Report** template when creating a new issue
3. Include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Discord screenshots (if applicable)
   - Your environment (OS, Python version, Discord.py version)

### ✨ Suggest Features
Have an idea? We love hearing them!

1. Check [existing discussions](https://github.com/welshDog/BROski-Bot/discussions)
2. Start a **Feature Discussion** with:
   - What problem does this solve?
   - How does it improve the community experience?
   - Example use case

### 📝 Improve Documentation
Typos? Confusing sections? Missing guides?

- Documentation PRs are always welcome
- Fix typos, clarify instructions, add examples
- No approval needed for small doc fixes

### 💻 Submit Code

#### Setup
```bash
git clone https://github.com/welshDog/BROski-Bot
cd BROski-Bot
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
```

#### Before You Code
1. Check open issues/PRs to avoid duplicate work
2. For larger changes, open an issue first to discuss approach
3. Follow the existing code style

#### Making Changes
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-number-description

# Make your changes...
python -m pytest tests/        # Run tests
python -m pylint cogs/         # Check code style

git add .
git commit -m "✨ Brief description of change"
git push origin feature/your-feature-name
```

#### PR Guidelines
- Keep PRs focused (one feature/fix per PR)
- Link to related issues: `Closes #123`
- Explain what the bot command/feature does
- Update tests if you changed functionality
- Update documentation if you changed behavior

## Development Guidelines

### Code Style
- Use **Black** for formatting
- Use **Pylint** for linting
- Follow Discord.py conventions
- Comment complex logic clearly

### Commits
- Use clear, descriptive commit messages
- Start with emoji: `✨` (feature), `🐛` (fix), `📝` (docs), `🔧` (config)
- Example: `✨ Add focus session timer command`

### Testing
- Write tests for new cogs/commands
- Ensure all tests pass: `python -m pytest`
- Test with real Discord bot if possible

### Discord Bot Development
- Follow [Discord.py best practices](https://discordpy.readthedocs.io/)
- Use proper error handling for bot commands
- Include helpful command usage examples
- Consider neurodivergent users (clear instructions, helpful responses)

## Questions or Need Help?

- **Discord:** [Join the BROski Community](#)
- **Discussions:** Start a [GitHub Discussion](https://github.com/welshDog/BROski-Bot/discussions)
- **Issues:** Ask in relevant issue threads

## Recognition

Contributors are recognized in:
- 📌 README.md (Contributors section)
- 🏆 Releases (when your code ships)
- 💰 BROski$ tokens (if applicable)
- 🤖 Bot credits

## License

By contributing, you agree your work will be licensed under `AGPL-3.0`. See `LICENSE` for details.

---

**Thank you for building community tools with us! 🚀**
