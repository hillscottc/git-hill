from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'django_proj1.views.home', name='home'),
    # url(r'^django_proj1/', include('django_proj1.foo.urls')),

    url(r'^shoes/$', 'shoe_app.views.index'),
    url(r'^shoes/(?P<shoe_id>\d+)/$','shoe_app.views.detail'),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
