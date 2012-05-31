import os.path
from django.conf.urls import patterns, include, url
from django.conf.urls.defaults import *
from views import project_index
from views import logout_page
#from shoe_app.views import *
from django.contrib import admin
from django.contrib.auth.views import login


admin.autodiscover()

site_media = os.path.join(os.path.dirname(__file__), 'site_media')


urlpatterns = patterns('',
    url(r'^$', project_index),
    #url(r'^admin/', include(admin.site.urls)),
    url(r'^login/$', 'django.contrib.auth.views.login'),
    url(r'^logout/$', logout_page),
    url(r'^site_media/(?P<path>.*)$',
      'django.views.static.serve', { 'document_root': site_media }),
    url(r'^shoe_app/', include('shoe_app.urls'))
)