import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

org_filename = sys.argv[1]
author = "Olai Solsvik"
# output_path = Path(sys.argv[1])

typst_root = Path(__file__).resolve().parent
ob_typst_preamble = typst_root / "ob-typst-preamble.typ"
typst_template = typst_root / "template.typ"
org_path = Path(org_filename).resolve()
content = org_path.read_text(encoding="utf-8")

org_dir = Path("~/notes/org").expanduser()
output_path = Path(f"~/Downloads/{org_path.stem}-{datetime.now().isoformat()}.pdf").expanduser()

title_match = re.search(r'^\s*#\+title:\s*(.+)$', content, re.IGNORECASE | re.MULTILINE)
title = title_match.group(1).strip() if title_match else org_path.stem
iso8601_date = datetime.now().strftime("%Y-%m-%d")

# Ensure math gets copied verbatim, as this is a non-standard org feature
# Regex taken directly from typst-overlay emacs to ensure equal results
math_regex = r'(?:\$[^\n$ ](?:[^$\n]*[^\n$ ])?\$|(?:^\s*\$\s*\n.*?\n\s*\$\s*))'
math_blocks = []
def stash_math(match):
    matched = match.group(0)
    math_blocks.append(matched)
    token = f"MATHBLOCKTOKEN{len(math_blocks) - 1}END"
    if "\n" in matched:
        return f"\n\n{token}\n\n"
    else:
        return token
content = re.sub(math_regex, stash_math, content, flags=re.MULTILINE | re.DOTALL)

typst_export_regex = r'^\s*#\+begin_src\s+typst[^\n]*\n(.*?)\n\s*#\+end_src(?:\s*#\+results:\s*\[\[file:.*?\]\])?'
typst_blocks = []
def stash_typst(match):
    typst_blocks.append(match.group(1).strip())
    return f"TYPSTBLOCKTOKEN{len(typst_blocks) - 1}END"
content = re.sub(typst_export_regex, stash_typst, content, flags=re.IGNORECASE | re.MULTILINE | re.DOTALL)

pandoc_result = subprocess.run(
    ["pandoc", "-f", "org", "-t", "typst"],
    input=content,
    text=True,
    capture_output=True,
    check=False,
)
if pandoc_result.returncode != 0:
    print("Pandoc conversion failed:")
    print(pandoc_result.stderr)
    sys.exit(1)
typst_body = pandoc_result.stdout

for i, typst_block in enumerate(typst_blocks):
    typst_body = typst_body.replace(f"TYPSTBLOCKTOKEN{i}END", typst_block)

for i, math_block in enumerate(math_blocks):
    typst_body = typst_body.replace(f"MATHBLOCKTOKEN{i}END", math_block)

typst_code = f"""
#let title = "{title}"
#let author = "{author}"
#let date = "{iso8601_date}"
#let colorscheme = "gruvbox"

{ob_typst_preamble.read_text(encoding="utf-8")}
{typst_template.read_text(encoding="utf-8")}
{typst_body}
"""

typst_result = subprocess.run(
    ["typst", "compile", "--root", org_dir, "-", str(output_path)],
    input=typst_code,
    text=True,
    capture_output=True,
    check=False,
)

if typst_result.returncode == 0:
    print(f"Successfully exported to: {output_path}")
else:
    print("Typst compilation failed:")
    print(typst_result.stderr)
    sys.exit(1)
