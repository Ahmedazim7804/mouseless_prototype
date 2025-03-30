#include "my_application.h"
#include <flutter_linux/flutter_linux.h>

struct _MyApplication
{
    GtkApplication parent_instance;
    char **dart_entrypoint_arguments;
    FlView *flutter_view;
    GtkWindow *window;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)