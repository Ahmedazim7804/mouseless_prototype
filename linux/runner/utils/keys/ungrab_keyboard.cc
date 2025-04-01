#include "../../my_application.h"
#include <iostream>
#include <flutter_linux/flutter_linux.h>

using namespace std;

static FlMethodResponse *handleXUnGrabKeyboard(MyApplication *self)
{
    GdkWindow *window = get_flutter_gdk_window(self);
    Display *display = GDK_DISPLAY_XDISPLAY(gdk_window_get_display(window));

    XUngrabKeyboard(display, CurrentTime);
    XFlush(display);

    cout << "XUngrabKeyboard called" << endl;

    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}