#include "../../my_application.h"
#include <iostream>
#include <gtk/gtk.h>
#include <gdk/gdkx.h> // Required for GDK/X11 specifics
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <flutter_linux/flutter_linux.h>

using namespace std;

static FlMethodResponse *handleXGrabKeyboard(MyApplication *self)
{

    GdkWindow *window = get_flutter_gdk_window(self);
    Display *display = GDK_DISPLAY_XDISPLAY(gdk_window_get_display(window));
    Window xid = GDK_WINDOW_XID(window);
    int grab_status = XGrabKeyboard(display, xid, True, GrabModeAsync, GrabModeAsync, CurrentTime);

    XFlush(display);

    if (grab_status == GrabSuccess)
    {
        cout << "XGrabKeyboard successfull! " << grab_status << endl;
    }
    else
    {
        cerr << "XGrabKeyboard failed with status code " << grab_status << endl;
    }

    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}