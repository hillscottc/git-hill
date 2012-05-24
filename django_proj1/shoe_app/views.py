from django.http import HttpResponse

def index(request):
    shoe_list = Shoe.objects.all().order_by('-add_date')[:5]
    t = loader.get_template('shoes/index.html')
    c = Context({
        'shoe_list': shoe_list,
    })
    return HttpResponse(t.render(c))

def detail(request, shoe_id):
    return HttpResponse("You're looking at shoe %s." % shoe_id)

