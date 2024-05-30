from django.http import HttpResponse
from django.shortcuts import render

def startseite(request):
    return HttpResponse("<h1>Willkommen zur API Startseite</h1><p>Bitte verwenden Sie den richtigen Endpunkt, um die API zu nutzen.</p>")
