from django.shortcuts import render

from time import time

# Create your views here.

def index(request):
    return render(request, 'index2.html', {'test': time()})

def my_new_view(request):
    return render(request, 'karbonara.html')