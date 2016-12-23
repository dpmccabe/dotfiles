import sublime, sublime_plugin
from os.path import dirname, realpath
import subprocess

class BuildAndClean(sublime_plugin.TextCommand):
  def run(self, edit):
    self.view.window().run_command("build")
    sublime.set_timeout_async(self.clean, 3000)

  def clean(self):
    subprocess.Popen("rm *.{log,aux,fdb_latexmk,synctex.gz,fls}", shell = True, cwd = dirname(realpath(self.view.file_name())))
