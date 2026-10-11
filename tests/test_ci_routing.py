from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
class Routing(unittest.TestCase):
    def test_free_hosted_formula_and_lint_are_bounded_and_pinned(self):
        text = (ROOT / '.github/workflows/ci.yml').read_text()
        hosted = "${{ vars.CI_HOSTED_LABEL || 'ubuntu-24.04-arm' }}"
        self.assertEqual(re.findall(r'^  ([a-z-]+):$', text.split('jobs:\n')[1], re.M), ['formula', 'lint'])
        self.assertEqual(re.findall(r'^    runs-on: (.+)$', text, re.M), [hosted])
        self.assertIn('    timeout-minutes: 10\n', text)
        self.assertEqual(re.findall(r'^      runner: (.+)$', text, re.M), [hosted])
        self.assertIn('runner_policy: fleet', text)
        self.assertIn('HOMEBREW_GITHUB_API_TOKEN: ${{ github.token }}', text)
        self.assertEqual(set(re.findall(r'willfell/wac\.lab\.actions/[^\s@]+@([^\s]+)', text)), {'v1.19.0'})
        self.assertEqual((ROOT / '.github/actionlint.yaml').read_text(), 'self-hosted-runner:\n  labels: []\n')
