class BooksController < ApplicationController
  def index
    @genre = params[:genre].presence_in(Book::GENRES)
    @books = @genre ? Book.where(genre: @genre) : Book.all
    @books = @books.order(:title)
  end

  def show
    @book = Book.find(params.expect(:id))
  end
end
