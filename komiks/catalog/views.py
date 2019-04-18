from django.shortcuts import render

from time import time

# Create your views here.

def index(request):
    return render(request, 'index.html', {'test': time()})
def kar(request):
    return render(request, 'karbonara.html')