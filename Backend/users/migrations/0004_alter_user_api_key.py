# Generated by Django 4.2.13 on 2025-01-10 13:48

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0003_alter_user_api_key'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='api_key',
            field=models.CharField(default='ff3f64c6b1bb2cc64936b90d23d92951b352ff5c', max_length=40, unique=True),
        ),
    ]
