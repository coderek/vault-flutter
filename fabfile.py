from fabric.api import cd, env, prefix, run, settings
from fabric.operations import local, put


def build():
  local("flutter packages pub run build_runner build --delete-conflicting-outputs")

def watch():
  local("flutter packages pub run build_runner watch")

def web():
  local("flutter run -d chrome --web-renderer html")
