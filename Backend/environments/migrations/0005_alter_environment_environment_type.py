# Generated by Django 4.2.13 on 2024-12-20 12:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('environments', '0004_alter_userenvironmentsubscription_environment_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='environment',
            name='environment_type',
            field=models.CharField(choices=[('aquarium', 'Aquarium'), ('pond', 'Pond'), ('lake', 'Lake'), ('sea', 'Sea'), ('pool', 'Pool'), ('other', 'Other')], max_length=50),
        ),
    ]