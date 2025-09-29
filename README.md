# 🧰 Customer Support Automation Toolkit

A practical toolkit for customer support teams and data specialists.  
Automate repetitive tasks, standardize communication in English and Spanish, and analyze support trends.

## 📦 What’s inside
- 🔍 Ticket Parser (CLI) — Extract timestamps, customer IDs, and error codes from raw logs.
- 🧹 Log Cleaner (CLI) — Remove noise (DEBUG/TRACE), blank lines, and duplicates.
- 📝 Email Template Generator (CLI) — Produce ready-to-send Markdown replies (EN/ES).
- 🎨 UI Dashboard — Preview templates, copy responses, and keep a clean style guide.
- 📊 SQL Snippets — Resolution time, recurring issues, and churn indicators.
- 🧪 Sample Data — A support log for testing parsing and cleaning.

## 🗂 Project structure
See repo root for directories and roles.

## 🚀 Quick start (Windows)
1. Open Command Prompt in `support-toolkit`.
2. Run tools:
   - Ticket parser:
     ```
     cli\ticket_parser.bat sample_data\support_log.txt output\parsed.csv
     ```
   - Log cleaner:
     ```
     cli\log_cleaner.bat sample_data\support_log.txt output\cleaned_log.txt
     ```
   - Email template generator:
     ```
     cli\email_template_gen.bat refund --lang es --name "Carlos R." --order "OR-5823" --ticket "TCK-1009" --out output\refund_es.md
     ```
3. Open `ui\index.html` to preview templates. For local file fetching, serve with:

(Or use any static server.)

## 🔧 Configuration
- Templates live in `templates/english` and `templates/spanish`. Edit wording to fit your brand.
- Update `utils/sql_snippets.sql` with your table names and fields.
- Adjust patterns in `cli\ticket_parser.bat` to match your log format.

## 🤝 Contributing
- Fork the repo
- Create a feature branch (`feature/new-tool`)
- Open a PR with clear description and examples

## 📜 License
MIT — free to use, modify, and share. See `LICENSE`.

## 👤 Author
Ruben — Customer Support & Data Specialist (EN/ES)

MIT License

Copyright (c) 2025 Ruben

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.