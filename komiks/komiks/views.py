from django.shortcuts import render

from time import time

# Create your views here.

def index(request):
    print('okkkk')
    return render(request, 'index.html', {'test': time()})