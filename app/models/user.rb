# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friend_sent, class_name: 'Friendship', foreign_key: 'sent_by_id', inverse_of: 'sent_by', dependent: :destroy
  has_many :friend_request, class_name: 'Friendship', foreign_key: 'sent_to_id', inverse_of: 'sent_to',
                            dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :fname, presence: true, length: { in: 3..15 }
  validates :lname, presence: true, length: { in: 3..15 }

  # Searches Friendship database and returns array, 'friends',
  # which contains records of all mutual friendships for current_user
  def friends
    my_friends = Friendship.friends.where('sent_by_id =?', id)
    friend_ids = []
    my_friends.each do |f|
      friend_ids << f.sent_to_id if f.sent_to_id != id
      friend_ids << f.sent_by_id if f.sent_by_id != id
    end

    # Adds the User record from each friend id retrieved into friends array
    friends = []
    friend_ids.each do |i|
      friends << User.find(i)
    end

    friends
  end

  # Returns all posts from this user's friends and self
  def friends_and_own_posts
    friends = friends()
    friends << User.find(id)
    our_posts = []
    friends.each do |f|
      f.posts.each do |p|
        our_posts << p
      end
    end

    our_posts
  end

  # Returns all users that current user has sent a friend request to but hasn't accepted or declined
  def pending_requests
    friends_requested = []
    friend_sent.each do |r|
      friends_requested << r.sent_to if r.status == false
    end

    friends_requested
  end

  # Returns all users that current user has recieved a friend request from but hasn't accepted or declined
  def recieved_requests
    friend_requests = []
    friend_request.each do |r|
      friend_requests << r.sent_by if r.status == false
    end

    friend_requests
  end
end
