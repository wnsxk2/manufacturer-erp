#!/usr/bin/env python3

import re
import sys
from pathlib import Path


HANGUL_PATTERN = re.compile(r"[\u1100-\u11ff\u3130-\u318f\uac00-\ud7a3]")
SKIPPED_PREFIXES = (
    "Merge ",
    "Revert ",
    "fixup! ",
    "squash! ",
)


def extract_description(header: str) -> str:
    if ":" not in header:
        return ""
    return header.split(":", 1)[1].strip()


def should_skip(header: str) -> bool:
    return header.startswith(SKIPPED_PREFIXES)


def check_commit_message(message: str) -> int:
    header = message.splitlines()[0] if message.splitlines() else ""
    if should_skip(header):
        return 0

    description = extract_description(header)
    if not description:
        return 0

    if HANGUL_PATTERN.search(description):
        return 0

    print(
        "Commit message description must contain Korean: "
        "`type(scope): 한글 설명`",
        file=sys.stderr,
    )
    return 1


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("Usage: check_commit_description_korean.py <commit-msg-file>", file=sys.stderr)
        return 2

    message = Path(argv[1]).read_text(encoding="utf-8")
    return check_commit_message(message)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
