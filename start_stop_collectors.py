import gtk
import signal
from engine.engine import Engine
from gui.main_gui import MainGUI
import os, sys

engine = Engine()
try:
    interval = sys.argv[1]
except:
    print("Defaulting to 10 seconds.")
    interval = 10

if __name__ == "__main__":
    gtk.threads_init()
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    MainGUI(engine, interval)
    gtk.main()
    pid = os.getpid()
    os.kill(pid, signal.SIGSTOP)
