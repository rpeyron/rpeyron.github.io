---
post_id: 1394
title: 'GtkDateTime Widget'
date: '2013-03-21T19:26:00+01:00'

author: 'Rémi Peyronnet'
layout: post
guid: '/2013/03/gtkdatetime-widget/'
slug: gtkdatetime-widget
permalink: /2013/03/gtkdatetime-widget/
tc-thumb-fld: 'a:2:{s:9:"_thumb_id";i:1522;s:11:"_thumb_type";s:10:"attachment";}'
post_slider_check_key: '0'
image: /files/2013/03/gtkdatetime_widget.jpg
categories:
    - Informatique
tags:
    - Blog
lang: en
---

GtkDateTime is a very simple widget to edit timestamps in GTK.

![](/files/2013/03/gtkdatetime_widget-1.jpg)

See source files below.

# Source

gtk\_datetime.h

```c
/*
 * gtk_datetime.h - GtkDateTime GTK widget 
 * (c) 2013 - Rémi Peyronnet - LGPL
 * v1.0
 */

#ifndef GTK_DATETIME_H_
#define GTK_DATETIME_H_

#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>

G_BEGIN_DECLS

#define GTK_DATETIME_TYPE            (gtk_datetime_get_type ())
#define GTK_DATETIME(obj)            (G_TYPE_CHECK_INSTANCE_CAST ((obj), GTK_DATETIME_TYPE, GtkDateTime))
#define GTK_DATETIME_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST ((klass), GTK_DATETIME_TYPE, GtkDateTimeClass))
#define IS_GTK_DATETIME(obj)         (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GTK_DATETIME_TYPE))
#define IS_GTK_DATETIME_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), GTK_DATETIME_TYPE))


typedef struct _GtkDateTime       GtkDateTime;
typedef struct _GtkDateTimeClass  GtkDateTimeClass;

struct _GtkDateTime
{
	GtkHBox hbox;

	GtkWidget * year;
	GtkWidget * month;
	GtkWidget * day;

	GtkWidget * hour;
	GtkWidget * minute;
	GtkWidget * second;

  /*
  GtkWidget *buttons[3][3];
	*/
};

struct _GtkDateTimeClass
{
  GtkHBoxClass parent_class;

  void (* gtk_datetime) (GtkDateTime *gdt);
};

GType 		gtk_datetime_get_type();
GtkWidget*  gtk_datetime_new();
time_t      gtk_datetime_get_timestamp(GtkDateTime *gdt);
void        gtk_datetime_set_timestamp(GtkDateTime *gdt, const time_t * timestamp);

G_END_DECLS


#endif /* GTK_DATETIME_H_ */
```

gtk\_datetime.c

```c
/*
 * gtk_datetime.c - GtkDateTime GTK widget 
 * (c) 2013 - Rémi Peyronnet - LGPL
 * v1.0
 *
 * History :
 *  v1.0  (21/03/2013) - Initial release
 */

#include "gtk_datetime.h"
#include <gtk/gtksignal.h>
#include <time.h>

enum {
  GTK_DATETIME_CHANGED_SIGNAL,
  LAST_SIGNAL
};

static void gtk_datetime_class_init    (GtkDateTimeClass *klass);
static void gtk_datetime_init          (GtkDateTime      *gdt);
static void gtk_datetime_changed(GtkWidget * widget, GtkDateTime * gdt);

static guint gtk_datetime_signals[LAST_SIGNAL] = { 0 };

GType 
gtk_datetime_get_type ()
{
  static GType gdt_type = 0;

  if (!gdt_type)
	{
	  const GTypeInfo gdt_info = 
	  {
			sizeof (GtkDateTimeClass),
			NULL, /* base_init */
			NULL, /* base_finalize */
			(GClassInitFunc) gtk_datetime_class_init,
			NULL, /* class_finalize */
			NULL, /* class_data */
			sizeof (GtkDateTime),
			0,
			(GInstanceInitFunc) gtk_datetime_init,
	  };

	  gdt_type = g_type_register_static (GTK_TYPE_HBOX, "GtkDateTime", &gdt_info, 0);
	}

  return gdt_type;
}

static void
gtk_datetime_class_init (GtkDateTimeClass *klass)
{
  gtk_datetime_signals[GTK_DATETIME_CHANGED_SIGNAL] = g_signal_new ("gtk_datetime_changed",
			G_TYPE_FROM_CLASS (klass),
			G_SIGNAL_RUN_FIRST | G_SIGNAL_ACTION,
			G_STRUCT_OFFSET (GtkDateTimeClass, gtk_datetime),
			NULL, 
			NULL,                
			g_cclosure_marshal_VOID__VOID,
			G_TYPE_NONE, 0);
}



static void
gtk_datetime_init (GtkDateTime *gdt)
{

#define GTK_CONTAINER_ADD_AND_SHOW(container, widget)  {   
		GtkWidget * gww = widget;	
		gtk_container_add(GTK_CONTAINER(container), gww); 
		gtk_widget_show(gww); 
	}

#define GTK_CONTAINER_NEW_SPINNER_AND_SHOW(container, spinnername, min, max)   
		spinnername = gtk_spin_button_new_with_range(min, max, 1);	
		gtk_container_add(GTK_CONTAINER(container), spinnername); 
		g_signal_connect(spinnername, "value-changed", G_CALLBACK(gtk_datetime_changed), (gpointer) gdt); 
		gtk_widget_show(spinnername); 

	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->day, 1, 31)
	GTK_CONTAINER_ADD_AND_SHOW(gdt, gtk_label_new(" / "));
	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->month, 1, 31)
	GTK_CONTAINER_ADD_AND_SHOW(gdt, gtk_label_new(" / "));
	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->year, 1970, 2038)
	GTK_CONTAINER_ADD_AND_SHOW(gdt, gtk_label_new("   "));
	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->hour, 0, 23)
	GTK_CONTAINER_ADD_AND_SHOW(gdt, gtk_label_new(" : "));
	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->minute, 0, 59)
	GTK_CONTAINER_ADD_AND_SHOW(gdt, gtk_label_new(" : "));
	GTK_CONTAINER_NEW_SPINNER_AND_SHOW(gdt, gdt->second, 0, 59)

#undef GTK_CONTAINER_ADD_AND_SHOW
#undef GTK_CONTAINER_NEW_SPINNER_AND_SHOW

}

GtkWidget*
gtk_datetime_new ()
{
  return GTK_WIDGET (g_object_new (gtk_datetime_get_type (), NULL));
}

void
gtk_datetime_set_timestamp(GtkDateTime *gdt, const time_t * timestamp)
{
	struct tm * timecomp;
	timecomp = <a href="http://www.opengroup.org/onlinepubs/009695399/functions/localtime.html">localtime</a>(timestamp);

#define SPIN_SET_VALUE_WITHOUT_SIGNAL(spin, value) 
	g_signal_handlers_block_matched  (spin, G_SIGNAL_MATCH_DATA, 0, 0, NULL, NULL, gdt); 
	gtk_spin_button_set_value ( spin, value ); 
	g_signal_handlers_unblock_matched  (spin, G_SIGNAL_MATCH_DATA, 0, 0, NULL, NULL, gdt);	

	if (timecomp != NULL)
	{
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->day ), timecomp->tm_mday);
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->month ), timecomp->tm_mon + 1);
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->year ), timecomp->tm_year + 1900);
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->hour ), timecomp->tm_hour);
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->minute ), timecomp->tm_min);
		SPIN_SET_VALUE_WITHOUT_SIGNAL ( GTK_SPIN_BUTTON ( gdt->second ), timecomp->tm_sec);
	}

#undef SPIN_SET_VALUE_WITHOUT_SIGNAL

}

time_t 
gtk_datetime_get_timestamp(GtkDateTime *gdt)
{
	struct tm timecomp;
	timecomp.tm_mday = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->day ));
	timecomp.tm_mon = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->month )) - 1;
	timecomp.tm_year = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->year )) - 1900;
	timecomp.tm_hour = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->hour ));
	timecomp.tm_min = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->minute ));
	timecomp.tm_sec = gtk_spin_button_get_value_as_int ( GTK_SPIN_BUTTON ( gdt->second ));
	return <a href="http://www.opengroup.org/onlinepubs/009695399/functions/mktime.html">mktime</a>(&timecomp);
}

static void gtk_datetime_changed(GtkWidget * widget, GtkDateTime * gdt)
{
	  g_signal_emit (gdt, gtk_datetime_signals[GTK_DATETIME_CHANGED_SIGNAL], 0);
}
```

test\_datetime.c

```c
/*

File to test gtk_datetime widget

Makefile :

test_datetime: test_datetime.c gtk_datetime.c gtk_datetime.h
	gcc -o test_time	test_datetime.c gtk_datetime.c `pkg-config gtk+-2.0 --libs --cflags`

*/

#include <stdlib.h>
#include <gtk/gtk.h>
#include "gtk_datetime.h"
#include <time.h>


void changed( GtkWidget *widget,   gpointer   data )
{
  time_t seltime;
  seltime = gtk_datetime_get_timestamp( GTK_DATETIME( widget ));
  <a href="http://www.opengroup.org/onlinepubs/009695399/functions/printf.html">printf</a>("SelTime = %ld n", seltime);
}


int main( int   argc, char *argv[] )
{
  GtkWidget *window;
  GtkWidget *gdt;
  time_t curtime;

  gtk_init (&argc, &argv);

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title (GTK_WINDOW (window), "Aspect Frame");  
  g_signal_connect (window, "destroy",   G_CALLBACK (<a href="http://www.opengroup.org/onlinepubs/009695399/functions/exit.html">exit</a>), NULL);  
  gtk_container_set_border_width (GTK_CONTAINER (window), 10);

  gdt = gtk_datetime_new ();

  gtk_container_add (GTK_CONTAINER (window), gdt);
  gtk_widget_show (gdt);

  <a href="http://www.opengroup.org/onlinepubs/009695399/functions/time.html">time</a>(&curtime);	
  gtk_datetime_set_timestamp( GTK_DATETIME( gdt ), &curtime);
  <a href="http://www.opengroup.org/onlinepubs/009695399/functions/printf.html">printf</a>("CurTime = %ld n", curtime);

  g_signal_connect (gdt, "gtk_datetime_changed",  G_CALLBACK (changed), NULL);

  gtk_widget_show (window);

  gtk_main ();

  return 0;
}
```