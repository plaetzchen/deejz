from django.contrib import admin
from party.models import PartyPlaylist, Song, SongVote, SongVeto

class SongInline(admin.TabularInline):
	model = Song

class PartyPlaylistAdmin(admin.ModelAdmin):
	model = PartyPlaylist
	inlines = [SongInline, ]

admin.site.register(PartyPlaylist, PartyPlaylistAdmin)

admin.site.register(Song)

admin.site.register(SongVote)
admin.site.register(SongVeto)