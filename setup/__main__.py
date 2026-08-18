from __future__ import annotations

import argparse
from pathlib import Path

from .config import CONFIGS
from .install import InstallError, install


ROOT = Path(__file__).resolve().parent.parent


def get_configs(names: list[str]):
    if names == ["all"]:
        return CONFIGS

    by_name = {config.name: config for config in CONFIGS}
    selected = []

    for name in names:
        try:
            selected.append(by_name[name])
        except KeyError:
            raise SystemExit(f"unknown config: {name}") from None

    return tuple(selected)


def cmd_install(names: list[str]) -> int:
    failed = False

    for config in get_configs(names):
        source = ROOT / config.source
        target = Path(config.target).expanduser()

        try:
            backup = install(source, target, ROOT)
        except InstallError as exc:
            print(f"  error: {config.name}: {exc}")
            failed = True
        except OSError as exc:
            print(f"  error: {config.name}: {exc}")
            failed = True
        else:
            if backup is None:
                print(f"  installed {config.name}")
            else:
                print(f"  installed {config.name} (backup: {backup})")

    return 1 if failed else 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="dotfiles",
        description="Install configurations from this repository.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    install_parser = subparsers.add_parser("install")
    install_parser.add_argument("configs", nargs="+", metavar="CONFIG")

    return parser


def main() -> int:
    args = build_parser().parse_args()

    if args.command == "install":
        return cmd_install(args.configs)

    return 1


if __name__ == "__main__":
    raise SystemExit(main())
