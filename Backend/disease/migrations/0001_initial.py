# Generated by Django 4.2.13 on 2024-10-13 12:18

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='DiseaseDetection',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fish_detected', models.BooleanField()),
                ('condition', models.CharField(max_length=255)),
                ('symptoms', models.TextField()),
                ('curing', models.TextField()),
                ('certainty', models.DecimalField(decimal_places=2, max_digits=5)),
                ('prompt_tokens', models.IntegerField()),
                ('completion_tokens', models.IntegerField()),
                ('total_tokens', models.IntegerField()),
                ('model_used', models.CharField(max_length=255)),
                ('time_taken', models.FloatField()),
                ('image_size', models.CharField(max_length=50)),
                ('timestamp', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]