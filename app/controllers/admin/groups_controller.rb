module Admin
  class GroupsController < Admin::BaseController
    before_action :set_group, only: %i[show edit update destroy]
  
    def index
      @q = Group.ransack(params[:q])
      @groups = @q.result.includes(:user).page(params[:page])
    end
  
    def show; end
  
    def new
      @group = Group.new
    end

    def edit; end
  
    def create
      @group = current_user.groups.build(group_params)
      respond_to do |format|
        if @group.save
          redirect_to group_url(@group), notice: 'Group was successfully created.'
        else
          render :new
        end
      end
    end

    def update
      respond_to do |format|
        if @group.update(group_params)
          redirect_to group_url(@group), notice: 'Group was successfully updated.' 
        else
          render :edit
        end
      end
    end
  
    def destroy
      @group.destroy
  
      respond_to do |format|
        redirect_to groups_url, notice: 'Group was successfully destroyed.' 
      end
    end
  
    private

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :description, :privacy).merge(user_id: current_user.id)
    end
  end
  
end

