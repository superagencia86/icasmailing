class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params[:comment])

    if @comment.save
      flash[:notice] = "Comentario añadido!"
    else
      flash[:error]  = "Existen errores en el formulario."
    end

    redirect_to polymorphic_path(eval("#{@comment.commentable_type}").find(@comment.commentable_id))
  end
end
