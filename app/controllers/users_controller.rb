# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
    @friends = current_user.friends
    @pending_requests = current_user.pending_requests
    @friend_requests = current_user.recieved_requests
  end

  def show
    @user = User.find(params[:id])
  end

  # Modifies current user's notice_seen column to true
  def saw_notification
    current_user.notice_seen = true
    current_user.save
  end
end
