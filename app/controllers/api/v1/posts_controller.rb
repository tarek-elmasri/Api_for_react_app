class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user! , except: [:show, :index]
  before_action :set_post , except: [:index, :create]
  before_action :post_owner , only: [:update , :destroy]

  def index
    posts=Post.order('created_at DESC')
    render json: {posts: posts},status: :ok
  end

  def create
    post= @current_user.posts.create(posts_params)
    if post.save
      render json: {post: post},staus: :ok
    else
      render json: {errors: post.errors},status: :unprocessable_entity
    end
  end

  def destroy
    if @post.delete
      render json: :ok
    else
      render json: {errors: @post.errors},status: :unprocessable_entity
    end
  end

  def update
    if @post.update(posts_params)
      render json: {post: @post},status: :ok
    else
      render json: {errors: @post.errors},status: :unprocessable_entity
    end
  end

  def show
    if @post.present?
      render json: {post: @post},status: :ok
    else
      render json: {errors: ['Post not found']},status: :unprocessable_entity
    end
  end

  private
  def set_post
    @post=Post.find_by(id: params[:id])
  end

  def posts_params
    params.permit(:title , :body)
  end

  def post_owner
    render json: {errors: ["Only post owner can update or delete"]},status: :unauthorized unless @post.accessable_by?(@current_user)
  end

end
