# Generated by Django 4.2.13 on 2024-08-22 08:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('logs', '0002_apilogentry_delete_logentry'),
    ]

    operations = [
        migrations.AddField(
            model_name='apilogentry',
            name='post_data',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='apilogentry',
            name='query_params',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='apilogentry',
            name='request_body',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='apilogentry',
            name='response_time',
            field=models.DurationField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='apilogentry',
            name='user',
            field=models.CharField(blank=True, max_length=150, null=True),
        ),
    ]