from django.shortcuts import render_to_response
from django.shortcuts import get_object_or_404
from django.http import HttpResponse
from shoe_app.models import Shoe
from django.views.generic import TemplateView

def index(request):
    shoe_list = Shoe.objects.all().order_by('-add_date')[:5]
    return render_to_response('shoes/index.html', {'shoe_list': shoe_list})

def detail(request, shoe_id):
    #return HttpResponse("You're looking at shoe %s." % shoe_id)
    p = get_object_or_404(Shoe, pk=shoe_id)
    return render_to_response('shoes/detail.html', {'shoe': p})

class AboutView(TemplateView):
    template_name = "shoes/about.html"


