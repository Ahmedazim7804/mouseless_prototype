#include "../my_application.h"
#include <iostream>
#include <flutter_linux/flutter_linux.h>

using namespace std;

GdkWindow *get_flutter_gdk_window(MyApplication *self)
{
    if (!self || !self->flutter_view)
    {
        cerr << "Native Error: Application instance or Flutter view is null." << std::endl;
        return nullptr;
    }

    // Get the GtkWindow widget associated with the FlView
    GtkWidget *gtk_widget = GTK_WIDGET(self->flutter_view);
    if (!gtk_widget)
    {
        cerr << "Native Error: Could not get GTK widget from FlView." << std::endl;
        return nullptr;
    }

    // IMPORTANT: Check if the widget is realized (has an associated GdkWindow)
    if (!gtk_widget_get_realized(gtk_widget))
    {
        cerr << "Native Warning: GTK widget is not realized yet. Cannot get GdkWindow." << std::endl;
        return nullptr;
    }

    // Get the GdkWindow from the GtkWindow widget
    GdkWindow *gdk_window = gtk_widget_get_window(gtk_widget);
    if (!gdk_window)
    {
        cerr << "Native Error: Could not get GdkWindow from GTK widget (gtk_widget_get_window returned null)." << std::endl;
    }
    return gdk_window;
}

static FlMethodResponse *handle_get_gdk_window_address(MyApplication *self)
{
    GdkWindow *window = get_flutter_gdk_window(self);
    if (window)
    {
        // Cast the pointer to an integer type that can hold a pointer address
        // intptr_t is specifically designed for this.
        intptr_t address = reinterpret_cast<intptr_t>(window);
        cout << "Native: Found GdkWindow* " << window << ", sending address: " << address << std::endl;
        // Create a Flutter value containing the integer address
        g_autoptr(FlValue) result = fl_value_new_int(address);
        // Return a success response containing the address
        return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    }
    else
    {
        cerr << "Native: Failed to get GdkWindow* to send address." << std::endl;
        // Return an error response to Dart
        return FL_METHOD_RESPONSE(fl_method_error_response_new(
            "UNAVAILABLE", "Could not get GDK window handle. Widget might not be realized.", nullptr));
        // Alternative: Send 0 or null on success channel if Dart handles that
        // g_autoptr(FlValue) result = fl_value_new_int(0); // Or fl_value_new_null();
        // return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
    }
}