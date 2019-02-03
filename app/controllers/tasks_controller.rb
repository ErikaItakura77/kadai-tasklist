class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :show, :update]

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを投稿しました。'
      render :edit 
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render :new
    end
  end
  
  def new
    @task = Task.new
  end
  
  def index
    # ログインしているユーザー（current_user）が持っているタスクをデーターベースから取ってきている
    # 取ってきたタスクを@tasksという変数に代入している
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page])
  end
  
  def show
    @task = current_user.tasks.find(params[:id])
  end

  def edit
     @task = Task.find(params[:id])
  end
  
 def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
 end
  
 def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_to tasks_url
 end
  
  private

  def task_params
    params.require(:task).permit(:status, :content, :user_id)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end


