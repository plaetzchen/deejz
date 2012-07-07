# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):

        # Changing field 'PartyPlaylist.name'
        db.alter_column('party_partyplaylist', 'name', self.gf('django.db.models.fields.CharField')(max_length=1024))
        # Adding field 'Song.title'
        db.add_column('party_song', 'title',
                      self.gf('django.db.models.fields.CharField')(max_length=1024, null=True),
                      keep_default=False)


    def backwards(self, orm):

        # Changing field 'PartyPlaylist.name'
        db.alter_column('party_partyplaylist', 'name', self.gf('django.db.models.fields.TextField')())
        # Deleting field 'Song.title'
        db.delete_column('party_song', 'title')


    models = {
        'party.partyplaylist': {
            'Meta': {'object_name': 'PartyPlaylist'},
            'address': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'longitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'default': '"It\'s my party."', 'max_length': '1024'}),
            'slug': ('django.db.models.fields.SlugField', [], {'default': "''", 'max_length': '50'})
        },
        'party.song': {
            'Meta': {'object_name': 'Song'},
            'deezer_id': ('django.db.models.fields.IntegerField', [], {'default': '3135556'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order': ('django.db.models.fields.IntegerField', [], {'default': '0'}),
            'party': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['party.PartyPlaylist']"}),
            'played': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '1024', 'null': 'True'}),
            'vetoed': ('django.db.models.fields.BooleanField', [], {'default': 'False'})
        }
    }

    complete_apps = ['party']