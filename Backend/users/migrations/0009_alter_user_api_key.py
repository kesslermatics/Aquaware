# Generated by Django 4.2.13 on 2025-03-23 20:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0008_alter_user_api_key'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='api_key',
            field=models.CharField(default='364ab1', max_length=40, unique=True),
        ),
    ]
