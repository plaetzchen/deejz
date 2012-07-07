# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'SongVote'
        db.create_table('party_songvote', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('song', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['party.Song'])),
            ('uuid', self.gf('django.db.models.fields.CharField')(max_length=1024)),
        ))
        db.send_create_signal('party', ['SongVote'])

        # Adding model 'SongVeto'
        db.create_table('party_songveto', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('song', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['party.Song'])),
            ('uuid', self.gf('django.db.models.fields.CharField')(max_length=1024)),
        ))
        db.send_create_signal('party', ['SongVeto'])

        # Deleting field 'Song.order'
        db.delete_column('party_song', 'order')


    def backwards(self, orm):
        # Deleting model 'SongVote'
        db.delete_table('party_songvote')

        # Deleting model 'SongVeto'
        db.delete_table('party_songveto')

        # Adding field 'Song.order'
        db.add_column('party_song', 'order',
                      self.gf('django.db.models.fields.IntegerField')(default=0),
                      keep_default=False)


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
            'party': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['party.PartyPlaylist']"}),
            'played': ('django.db.models.fields.DateTimeField', [], {'null': 'True', 'blank': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '1024', 'null': 'True'}),
            'vetoed': ('django.db.models.fields.BooleanField', [], {'default': 'False'})
        },
        'party.songveto': {
            'Meta': {'object_name': 'SongVeto'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'song': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['party.Song']"}),
            'uuid': ('django.db.models.fields.CharField', [], {'max_length': '1024'})
        },
        'party.songvote': {
            'Meta': {'object_name': 'SongVote'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'song': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['party.Song']"}),
            'uuid': ('django.db.models.fields.CharField', [], {'max_length': '1024'})
        }
    }

    complete_apps = ['party']