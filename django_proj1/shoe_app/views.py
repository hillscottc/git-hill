from django.shortcuts import render_to_response
from django.shortcuts import get_object_or_404
from django.http import HttpResponse
from django.http import Http404
from django.http import HttpResponseRedirect
from django.template import Context
from django.template.loader import get_template
from shoe_app.models import Shoe
from shoe_app.models import ShoeForm
from django.views.generic import TemplateView
from django.template import RequestContext
from django.contrib import auth
from django.contrib.auth.models import User
from django.contrib.auth import logout

def index(request):
    return render_to_response(
        'shoe_app/index.html',
        {'user': request.user},
        context_instance=RequestContext(request))

def user_page(request, username):
    user = get_object_or_404(User, username='hills')
    shoe_list = Shoe.objects.all().order_by('-add_date')[:5]
    return render_to_response(
        'shoe_app/user_page.html',
        {'shoe_list': shoe_list, 'username': username},
        context_instance=RequestContext(request))


def detail(request, shoe_id):
    #return HttpResponse("You're looking at shoe %s." % shoe_id)
    p = get_object_or_404(Shoe, pk=shoe_id)
    return render_to_response('shoe_app/detail.html', {'shoe': p})


def shoe_handler(request):
    if request.method == 'POST':
        form = ShoeForm(request.POST) # form bound to  POST data
        if form.is_valid(): # All validation rules pass
            # Process the data in form.cleaned_data
            # ...
            return HttpResponseRedirect('/shoe_app/thanks/') # Redirect after POST
    else:
        form = ShoeForm() # An unbound form

    return render_to_response('shoe_app/shoe_add_edit.html',
        {'form': form,},
        context_instance=RequestContext(request))

class AboutView(TemplateView):
    template_name = "shoe_app/about.html"

