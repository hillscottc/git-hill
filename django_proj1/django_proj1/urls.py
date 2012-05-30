from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.contrib.auth.views import login


admin.autodiscover()

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    url(r'^login/$', 'django.contrib.auth.views.login'),

    url(r'^shoe_app/', include('shoe_app.urls')),



)