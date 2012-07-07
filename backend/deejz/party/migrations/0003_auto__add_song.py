# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Song'
        db.create_table('party_song', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('party', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['party.PartyPlaylist'])),
            ('deezer_id', self.gf('django.db.models.fields.IntegerField')(default=3135556)),
            ('played', self.gf('django.db.models.fields.DateTimeField')(null=True, blank=True)),
            ('order', self.gf('django.db.models.fields.IntegerField')(default=0)),
            ('vetoed', self.gf('django.db.models.fields.BooleanField')(default=False)),
        ))
        db.send_create_signal('party', ['Song'])


    def backwards(self, orm):
        # Deleting model 'Song'
        db.delete_table('party_song')


    models = {
        'party.partyplaylist': {
            'Meta': {'object_name': 'PartyPlaylist'},
            'address': ('django.db.models.fields.TextField', [], {'blank': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'longitude': ('django.db.models.fields.FloatField', [], {'null': 'True', 'blank': 'True'}),
            'name': ('django.db.models.fields.TextField', [], {'default': '"It\'s my party."'}),
            'slug': ('django.db.models.fields.SlugField', [], {'default': "''", 'max_length': '50'})
        },
        'party.song': {
            'Meta': {'object_name': 'Song'},
            'deezer_id': ('django.db.models.fields.IntegerField', [], {'default': '3135556'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order': ('django.db.models.fields.IntegerField', [], {'default': '0'}),
            'party': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['party.PartyPlaylist']"}),
            'played': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'vetoed': ('django.db.models.fields.BooleanField', [], {'default': 'False'})
        }
    }

    complete_apps = ['party']