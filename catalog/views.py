from django.shortcuts import render

# Create your views here.
from .models import Author, Book, BookInstance, Genre


def index(request):
    """View function for home page of site."""

    # Generate counts of some of the main objects
    num_books = Book.objects.all().count()
    num_instances = BookInstance.objects.all().count()

    # Available books (status = 'a')
    num_instances_available = BookInstance.objects.filter(status__exact="a").count()

    # The 'all()' is implied by default.
    num_authors = Author.objects.count()

    # Number of Books with Dune in the title
    num_dune = Book.objects.filter(title__icontains="dune").count()

    # Number of Genres with Fiction in the name
    num_fiction = Genre.objects.filter(name__icontains="fiction").count()

    context = {
        "num_books": num_books,
        "num_instances": num_instances,
        "num_instances_available": num_instances_available,
        "num_authors": num_authors,
        "num_dune": num_dune,
        "num_fiction": num_fiction,
    }

    # Render the HTML template index.html with the data in the context variable
    return render(request, "index.html", context=context)
