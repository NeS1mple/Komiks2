from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'karbonara/$', views.my_new_view),
    url(r'', views.index)
]