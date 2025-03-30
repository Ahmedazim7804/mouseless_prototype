#include "../my_application.h"
#include <iostream>
#include <flutter_linux/flutter_linux.h>

using namespace std;

static FlMethodResponse *set_window_redirect_override(MyApplication *self)
{
    GdkWindow *window = get_flutter_gdk_window(self);

    // Get the underlying GdkWindow.
    if (window)
    {
        // Set the redirect override for the GdkWindow
        gdk_window_set_override_redirect(window, TRUE);
        cout << "Native: Set GdkWindow* " << window << " to override redirect." << std::endl;
        return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(TRUE)));
    }
    else
    {
        cerr << "Native: Failed to set GdkWindow* to override redirect." << std::endl;
        return FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(FALSE)));
    }
}