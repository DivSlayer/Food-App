# myapp/management/commands/startall.py
import os
from pathlib import Path

from django.core.management.base import BaseCommand
from django.core.management import call_command
from django.apps import apps

VENV_NAMES = ('venv', 'env', '.venv')


class Command(BaseCommand):
    help = "Run all custom commands in INSTALLED_APPS, then start the dev server."

    def find_project_root(self):
        """Return absolute path of the directory containing this script (project root)."""
        return os.getcwd()

    def handle(self, *args, **options):
        # 1) Gather app configs
        root = self.find_project_root()
        app_configs = apps.get_app_configs()
        app_paths = [Path(p.path).as_posix() for p in apps.get_app_configs()]
        venv_prefixes = [(Path(root) / venv).as_posix() for venv in VENV_NAMES]
        # one‐liner to both normalize and filter out any venv folders
        excluded_apps = [
            p for p in app_paths
            if not any(p.startswith(prefix) for prefix in venv_prefixes)
        ]
        print(excluded_apps)
        # 2) For each app, look for management/commands/*.py
        cmds = []
        for cfg in excluded_apps:
            cmd_dir = os.path.join(cfg, 'management', 'commands')
            if os.path.isdir(cmd_dir):
                for fn in os.listdir(cmd_dir):
                    if fn.endswith('.py') and fn != '__init__.py':
                        cmds.append(fn[:-3])
        cmds = sorted(set(cmds))
        print(excluded_apps)
        # 3) Run each custom command
        if cmds:
            self.stdout.write(self.style.SUCCESS("🚀 Running custom management commands…"))
            for cmd in cmds:
                self.stdout.write(f" → {cmd}")
                call_command(cmd)
        else:
            self.stdout.write(self.style.WARNING("ℹ️ No custom commands found."))

        # 4) Finally, run the dev server (blocks here)
        self.stdout.write(self.style.SUCCESS("🎉 Starting dev server at http://127.0.0.1:8000/"))
        call_command('runserver', '127.0.0.1:8000')
