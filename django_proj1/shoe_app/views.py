from django.shortcuts import render_to_response
from django.shortcuts import get_object_or_404
from django.http import HttpResponseRedirect, HttpResponse
from shoe_app.models import Shoe
from shoe_app.models import ShoeForm
from django.views.generic import TemplateView
from django.template import RequestContext
from django.contrib import auth

def index(request):
    shoe_list = Shoe.objects.all().order_by('-add_date')[:5]
    return render_to_response('shoe_app/index.html',
        {'shoe_list': shoe_list},
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

# def login_view(request):
#     username = request.POST.get('username', '')
#     password = request.POST.get('password', '')
#     user = auth.authenticate(username=username, password=password)
#     if user is not None and user.is_active:
#         # Correct password, and the user is marked "active"
#         auth.login(request, user)
#         # Redirect to a success page.
#         return HttpResponseRedirect("/shoe_app/")
#     else:
#         # Show an error page
#         return HttpResponseRedirect("/shoe_app/invalid/")


class AboutView(TemplateView):
    template_name = "shoe_app/about.html"

class ThanksView(TemplateView):
    template_name = "shoe_app/thanks.html"

class InvalidLoginView(TemplateView):
    template_name = "shoe_app/invalid.html"
