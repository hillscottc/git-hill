from django.conf.urls import patterns, include, url
from shoe_app.views import AboutView
from shoe_app.views import ThanksView
from django.views.generic import ListView
from shoe_app.models import Shoe


urlpatterns = patterns('shoe_app.views',
    url(r'^$', 'index'),
    url(r'^shoes/$', ListView.as_view(
        model=Shoe,
    )),
    url(r'^shoes/(?P<shoe_id>\d+)/$','detail'),
    url(r'^shoe_handler/$', 'shoe_handler'),
    url(r'^about/$', AboutView.as_view()),
    url(r'^thanks/$', ThanksView.as_view()),
)
