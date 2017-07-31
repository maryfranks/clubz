class ClubsController < ApplicationController

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find(params[:id])

    if current_user
      if current_user == @club.user
        render :show
      elsif current_user.allowed?
        render :show
      else
        redirect_to root_path
      end
    else
      redirect_to new_session_path
    end

    # unless current_user && current_user.allowed?
    #   redirect_to root_path
    # end
    #
    # @club = Club.find(params[:id])

    # if current_user
    #   @club = Club.find(params[:id])
    #   render :show
    # else
    #   redirect_to new_session_path
    # end
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(
      name: params[:club][:name],
      description: params[:club][:description],
      user: current_user
    )

    if @club.save
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :new
    end
  end

  def edit
    @club = Club.find(params[:id])
  end

  def update
    @club = Club.find(params[:id])

    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

end
