from __future__ import annotations

import os
import shutil
import tempfile
from datetime import datetime
from pathlib import Path


class InstallError(Exception):
    pass


def _backup_path(target: Path) -> Path:
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    candidate = target.with_name(f"{target.name}.backup-{stamp}")
    counter = 1

    while candidate.exists() or candidate.is_symlink():
        candidate = target.with_name(f"{target.name}.backup-{stamp}-{counter}")
        counter += 1

    return candidate


def _copy(source: Path, destination: Path) -> None:
    if source.is_dir():
        shutil.copytree(source, destination, symlinks=False, copy_function=shutil.copy2)
    else:
        shutil.copy2(source, destination)


def _validate(source: Path, target: Path, repo_root: Path) -> None:
    source = source.resolve()
    repo_root = repo_root.resolve()

    if not source.exists():
        raise InstallError(f"source does not exist: {source}")

    if not source.is_relative_to(repo_root):
        raise InstallError(f"source is outside repository: {source}")

    if target.is_symlink():
        raise InstallError(f"target is a symlink; refusing to replace it: {target}")

    try:
        target.resolve(strict=False).relative_to(repo_root)
    except ValueError:
        pass
    else:
        raise InstallError(f"target is inside repository: {target}")


def install(source: Path, target: Path, repo_root: Path) -> Path | None:
    source = source.resolve()
    target = target.expanduser()
    repo_root = repo_root.resolve()

    _validate(source, target, repo_root)
    target.parent.mkdir(parents=True, exist_ok=True)

    backup: Path | None = None

    # Stage beside the target so the final rename remains on the same
    # filesystem. Nothing touches the target until staging succeeds.
    with tempfile.TemporaryDirectory(
        prefix=f".{target.name}.install-",
        dir=target.parent,
    ) as tmpdir:
        staged = Path(tmpdir) / target.name
        _copy(source, staged)

        if target.exists():
            backup = _backup_path(target)
            os.replace(target, backup)

        try:
            os.replace(staged, target)
        except BaseException:
            if backup is not None and not target.exists():
                os.replace(backup, target)
            raise

    return backup
