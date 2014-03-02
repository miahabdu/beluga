class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order('created_at DESC')
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @posts = Post.all
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post_image = @post.images.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @images = params[:images][:filename] rescue nil
        if @images
          @images.each do |i|
            @post_image = @post.images.create!(filename: i, post_id: @post.id)
          end
        end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.images.each { |f| f.delete } if @post.images.any?
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
      @images = Post.try(:images)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :category, :user_id, :tag_list, images_attributes: [:id, :post_id, :filename, :name])
    end
end
