class PostsController < ApplicationController

  layout('standard', :except => :list_newest)
  
  def new
    @post = Post.new
  end

  def index
    @post = Post.find(:first, :order => 'date DESC')
    redirect_to(:action => :show, :id => @post.id);
  end

  def create
    #rails3: @post = Post.new(params[:post])
    @post = Post.create(params.require(:post).permit(:title, :description, :date, :image_file, :thumbnail_file))
    if !@post.valid?
      flash.now[:notice] = "Bitte f&uuml;llen Sie alle Felder aus und &uuml;berpr&uuml;fen Sie Ihre Angaben."
      render(:action => :new)
    elsif !@post.save_files
      flash.now[:notice] = "Es trat ein Fehler beim Hochladen der Dateien auf."
      render(:action => :new)
    else
      @post.save
      flash[:notice] = "Dateien wurden hochgeladen und die Daten gespeichert."
      redirect_to(:action => :list)
    end
  end

  def list
    @posts = Post.find(:all, :order => 'date DESC') ###deprecated!!!
  #@posts = Post.where(:published => true).paginate(:page => params[:page])
  #@posts = Post.find(:all, :order => 'date DESC').paginate(:page => params[:page])
  #Post.page(params[:page]).order('created_at DESC')
  end

  def list_newest
    @newest_posts = Post.find(:all, :limit => 5, :order => 'date DESC')
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params.require(:post).permit(:title, :description, :date))
      flash[:notice] = "Ihre Änderungen wurden gespeichert."
      redirect_to(:action => :list)
    else
      flash.now[:notice] = "Es trat ein Fehler auf. Bitte füllen Sie alle Felder aus und überprüfen Sie Ihre Angaben."
      render(:action => :edit)
    end
  end

  def delete
    @post = Post.destroy(params[:id])
    flash[:notice] = "Das Bild <strong>#{@post.title}</strong> wurde gelöscht."
    redirect_to(:action => :list)
  end

  def show
    @post = Post.find(params[:id])
    # Vorheriges / nächstes Foto
    @posts = Post.find(:all, :order => 'date DESC')
    @next_post = @posts[@posts.index(@post) + 1] unless @post == @posts.last
    @prev_post = @posts[@posts.index(@post) - 1] unless @post == @posts.first
    # Neuer Kommentar
    @comment = Comment.new
  end

  def create_comment
    #rails3: @comment = Comment.new(params[:comment])
    @comment = Comment.create(params.require(:comment).permit(:name, :url, :email, :text))
    @post = Post.find(params[:id])
    if @comment.valid?
      @post.comments << @comment
      flash[:notice] = 'Vielen Dank für Ihren Kommentar.'
      redirect_to(:action => :show, :id => @post.id)
    else
      Flash.now[:notice] = 'Bitte füllen Sie alle benötigten Felder aus.'
      render(:action => :show, :id => @post.id)
    end
  end

  def delete_comment
    @comment = Comment.destroy(params[:id])
    flash[:notice] = 'Kommentar wurde entfernt.'
    redirect_to(:action => :show, :id => @comment.post_id)
  end

end
