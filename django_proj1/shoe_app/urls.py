from django.conf.urls import patterns, include, url

urlpatterns = patterns('shoe_app.views',
    url(r'^$', 'index'),
    url(r'^(?P<shoe_id>\d+)/$','detail'),
)

