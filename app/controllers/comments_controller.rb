class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_photo, only: [:create], if: -> { params[:comment][:photo_id].present? }
  before_action :authorize_resource, except: [:create]
  before_action :authorize_create_action, only: [:create]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /comments
  def index
    # Including associations to avoid N+1 queries
    @comments = policy_scope(Comment).includes(:author, :photo)
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = @photo.comments.build(comment_params.merge(author: current_user))
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @photo, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_photo
    @photo = Photo.find(params[:comment][:photo_id])
  end

  def authorize_resource
    authorize @comment || Comment
  end

  def authorize_create_action
    authorize @photo, :show?
  end

  def comment_params
    params.require(:comment).permit(:photo_id, :body)
  end

  def record_not_found
    redirect_to comments_path, alert: 'Comment not found.'
  end
end
