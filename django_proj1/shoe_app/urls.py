from django.conf.urls import patterns, include, url
from shoe_app.views import AboutView
from shoe_app.views import ThanksView
from shoe_app.views import InvalidLoginView
from django.views.generic import ListView
from shoe_app.models import Shoe
#from django.contrib.auth.views import login

urlpatterns = patterns('shoe_app.views',
    url(r'^$', 'index'),
    url(r'^shoes/$', ListView.as_view(
        model=Shoe,
    )),
    url(r'^shoes/(?P<shoe_id>\d+)/$','detail'),
    url(r'^shoe_handler/$', 'shoe_handler'),

    #url(r'^login/$', 'django.contrib.auth.views.login'),


    url(r'^invalid/$', InvalidLoginView.as_view()),
    url(r'^about/$', AboutView.as_view()),
    url(r'^thanks/$', ThanksView.as_view()),
)
