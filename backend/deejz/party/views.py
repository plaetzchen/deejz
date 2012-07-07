from django.http import HttpResponse
from django.shortcuts import render_to_response
from party.models import PartyPlaylist
from django.template import RequestContext
from django.core import serializers

def index(request):
	return HttpResponse("index")
	
def party(request, party_slug):
	playlist = PartyPlaylist.objects.get(slug=party_slug)
	context = RequestContext(request, {'party': playlist, 'songs': playlist.song_set.all() })
	return render_to_response('party.html', context)
	
def playlist_json(request, party_slug):
	fete = PartyPlaylist.objects.get(slug=party_slug)
	data = serializers.serialize("json", fete.song_set.all())
	return HttpResponse(data, mimetype="application/json")

def details_json(request, party_slug):
	data = serializers.serialize("json", [PartyPlaylist.objects.get(slug=party_slug)])
	return HttpResponse(data, mimetype="application/json")
	
def add_song(request, party_slug):
	fete = PartyPlaylist.objects.get(slug=party_slug)
	
		
def create_party(request):
	autoslug = ''.join(random.sample(string.ascii_lowercase, 10))
	return HttpResponse("create party-playlist")
	
def vote(request, party_slug):
	return HttpResponse("vote")
	
def veto(request, party_slug):
	return HttpResponse("VETO")