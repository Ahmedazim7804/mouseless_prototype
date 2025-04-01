#include <iostream>
#include "../my_application.h"
#include "gdk_window_address.cc"
#include "set_window_redirect.cc"
#include "show_hide_window.cc"
#include "keys/grab_keys.cc"
#include "keys/ungrab_keyboard.cc"

#include <flutter_linux/flutter_linux.h>

using namespace std;

static void platform_channel_method_call_handler(FlMethodChannel *channel, FlMethodCall *method_call, gpointer user_data)
{
    // Get the application instance from user_data
    MyApplication *self = MY_APPLICATION(user_data);
    // Get the method name called from Dart
    const gchar *method = fl_method_call_get_name(method_call);

    cout << "Platform channel method call handler invoked." << endl;

    g_autoptr(FlMethodResponse) response = nullptr;

    // Check which method Dart called
    if (strcmp(method, "getGdkWindowAddress") == 0)
    {
        response = handle_get_gdk_window_address(self);
    }
    else if (strcmp(method, "setRedirectOverride") == 0)
    {
        response = set_window_redirect_override(self);
    }
    else if (strcmp(method, "showWindow") == 0)
    {
        response = handle_show_window(self);
    }
    else if (strcmp(method, "hideWindow") == 0)
    {
        response = handle_hide_window(self);
    }
    else if (strcmp(method, "grabKeyboard") == 0)
    {
        response = handleXGrabKeyboard(self);
    }
    else if (strcmp(method, "unGrabKeyboard") == 0)
    {
        response = handleXUnGrabKeyboard(self);
    }
    else
    {
        response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    }

    // Send the response back to Dart
    // TRUE means the framework shouldn't print an error if the response is null
    g_autoptr(GError) error = nullptr;
    if (!fl_method_call_respond(method_call, response, &error))
    {
        g_warning("Failed to send platform channel response: %s", error->message);
    }
}