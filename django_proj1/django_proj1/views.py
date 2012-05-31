from django.http import HttpResponse
from django.http import HttpResponseRedirect

def project_index(request):
     output = '''
       <html>
         <head>
            <title>%s</title></head>
         <body>
           <h1>%s</h1>
           <p><a href='%s'>%s</a></p>
         </body>
       </html>
     ''' % (
       'Django1 Dev Project',
       'Welcome to Django1 Dev Project',
       '/shoe_app/',
       'demo Shoe App'
     )
     return HttpResponse(output)


def logout_page(request):
    logout(request)
    return HttpResponseRedirect('/')




