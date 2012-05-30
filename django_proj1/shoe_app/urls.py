from django.conf.urls import patterns, include, url
from shoe_app.views import AboutView
from django.views.generic import ListView
from shoe_app.models import Shoe
#from django.contrib.auth.views import login

urlpatterns = patterns('shoe_app.views',
    # url(r'^shoes/$', ListView.as_view(model=Shoe,)),
    # url(r'^shoes/(?P<shoe_id>\d+)/$','detail'),
    # url(r'^shoe_handler/$', 'shoe_handler'),
    # url(r'^invalid/$', InvalidLoginView.as_view()),
    url(r'^about/$', AboutView.as_view()),
)
