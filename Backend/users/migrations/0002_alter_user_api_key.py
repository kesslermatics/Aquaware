# Generated by Django 4.2.13 on 2025-01-10 13:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='api_key',
            field=models.CharField(default='788080f0e96973e8769522a95497b5fe5dbc249b', editable=False, max_length=40, unique=True),
        ),
    ]
