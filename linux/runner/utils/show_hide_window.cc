#include "../my_application.h"
#include <iostream>
#include <flutter_linux/flutter_linux.h>

using namespace std;

static FlMethodResponse *handle_hide_window(MyApplication *self)
{
    if (!self || !self->window)
    {
        cerr << "Native Error: Cannot hide window, pointer is null." << std::endl;
        return FL_METHOD_RESPONSE(fl_method_error_response_new(
            "NULL_POINTER", "Native top_level_window pointer is null.", nullptr));
    }
    cout << "Native: Hiding window: " << self->window << std::endl;
    // Use gtk_widget_hide() on the GtkWindow
    gtk_widget_hide(GTK_WIDGET(self->window));
    // Return success (no data needed)
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

// >>> NEW: Handler for showing the window <<<
static FlMethodResponse *handle_show_window(MyApplication *self)
{
    if (!self || !self->window)
    {
        cerr << "Native Error: Cannot show window, pointer is null." << std::endl;
        return FL_METHOD_RESPONSE(fl_method_error_response_new(
            "NULL_POINTER", "Native top_level_window pointer is null.", nullptr));
    }
    cout << "Native: Showing window: " << self->window << std::endl;
    gtk_widget_show_all(GTK_WIDGET(self->window)); // Often safer for top-level
    return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}
