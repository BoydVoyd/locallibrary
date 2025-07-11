# Generated by Django 5.2.3 on 2025-06-24 01:46

import django.db.models.deletion
import uuid
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("catalog", "0002_language_book_language"),
    ]

    operations = [
        migrations.CreateModel(
            name="BookInstance",
            fields=[
                (
                    "id",
                    models.UUIDField(
                        default=uuid.uuid4,
                        help_text="Unique ID for this particular book across whole library",
                        primary_key=True,
                        serialize=False,
                    ),
                ),
                ("imprint", models.CharField(max_length=200)),
                ("due_back", models.DateField(blank=True, null=True)),
                (
                    "status",
                    models.CharField(
                        blank=True,
                        choices=[
                            ("m", "Maintenance"),
                            ("o", "On loan"),
                            ("a", "Available"),
                            ("r", "Reserved"),
                        ],
                        default="m",
                        help_text="Book availability",
                        max_length=1,
                    ),
                ),
                (
                    "book",
                    models.ForeignKey(
                        null=True,
                        on_delete=django.db.models.deletion.RESTRICT,
                        to="catalog.book",
                    ),
                ),
            ],
            options={
                "ordering": ["due_back"],
            },
        ),
    ]
