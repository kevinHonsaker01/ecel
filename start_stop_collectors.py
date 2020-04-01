import gtk
import signal
from engine.engine import Engine
from gui.main_gui import MainGUI
import os

engine = Engine()

if __name__ == "__main__":
    gtk.threads_init()
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    MainGUI(engine)
    gtk.main()
    pid = os.getpid()
    os.kill(pid, signal.SIGSTOP)
