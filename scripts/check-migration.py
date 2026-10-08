#!/usr/bin/env python3
"""Compare evaluated manifests without building or activating either system."""
import argparse
import json
import subprocess
import sys
from pathlib import Path


def differences(expected, actual, path=""):
    if isinstance(expected, dict) and isinstance(actual, dict):
        for key in sorted(expected.keys() | actual.keys()):
            child = f"{path}.{key}" if path else key
            if key not in expected or key not in actual:
                yield child, expected.get(key, "<missing>"), actual.get(key, "<missing>")
            else:
                yield from differences(expected[key], actual[key], child)
    elif expected != actual:
        yield path, expected, actual


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hosts", nargs="*", default=["stormbringer", "mjolnnir", "bifrost"])
    parser.add_argument("--output", type=Path, help="Directory for full evaluated JSON reports")
    args = parser.parse_args()
    root = Path(__file__).resolve().parent.parent
    failed = False
    for host in args.hosts:
        if host not in ["stormbringer", "mjolnnir", "bifrost"]:
            parser.error(f"unknown host: {host}")
        command = ["nix", "eval", "--impure", "--json", "--no-write-lock-file",
                   "--file", "tests/migration.nix", "--apply",
                   f'f: f {{ host = "{host}"; }}']
        result = subprocess.run(command, cwd=root, text=True, stdout=subprocess.PIPE)
        if result.returncode:
            failed = True
            continue
        report = json.loads(result.stdout)
        changes = list(differences(report["expected"], report["actual"]))
        if args.output:
            args.output.mkdir(parents=True, exist_ok=True)
            (args.output / f"{host}.json").write_text(json.dumps(report, indent=2) + "\n")
        print(f"{host}: {len(changes)} unexpected differences")
        for path, expected, actual in changes:
            print(f"  {path}\n    expected: {str(expected)[:500]}\n    actual:   {str(actual)[:500]}")
        failed |= bool(changes)
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
