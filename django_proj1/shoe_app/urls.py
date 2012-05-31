from django.conf.urls import patterns
from django.conf.urls import include
from django.conf.urls import url
from django.views.generic import ListView
from shoe_app.models import *
from shoe_app.views import *


urlpatterns = patterns('shoe_app.views',
    url(r'^$', index),
    # url(r'^shoes/$', ListView.as_view(model=Shoe,)),
    # url(r'^shoes/(?P<shoe_id>\d+)/$','detail'),
    # url(r'^shoe_handler/$', 'shoe_handler'),
    # url(r'^invalid/$', InvalidLoginView.as_view()),
    url(r'^about/$', AboutView.as_view()),
)
