import unittest
from contextlib import redirect_stderr
from io import StringIO

from scripts.check_commit_description_korean import (
    check_commit_message,
    extract_description,
)


class CommitDescriptionKoreanTest(unittest.TestCase):
    def test_extracts_description_from_conventional_commit_header(self):
        self.assertEqual(
            extract_description("feat(api)!: 주문 등록 기능 추가"),
            "주문 등록 기능 추가",
        )

    def test_accepts_description_containing_korean(self):
        self.assertEqual(check_commit_message("docs: 브랜칭 문서 추가\n"), 0)

    def test_rejects_description_without_korean(self):
        with redirect_stderr(StringIO()):
            self.assertEqual(check_commit_message("docs: add branching docs\n"), 1)

    def test_skips_git_generated_messages(self):
        self.assertEqual(check_commit_message("Merge branch 'main'\n"), 0)
        self.assertEqual(check_commit_message("Revert \"docs: add docs\"\n"), 0)
        self.assertEqual(check_commit_message("fixup! docs: add docs\n"), 0)
        self.assertEqual(check_commit_message("squash! docs: add docs\n"), 0)


if __name__ == "__main__":
    unittest.main()
