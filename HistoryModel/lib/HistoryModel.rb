require "HistoryModel/version"

module HistoryModel
  # History Model
  require 'elasticsearch/model'
  
  require_relative 'application_record.rb'
  require_relative 'application_controller.rb'

  module Model
    class History < ApplicationRecord
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
      mapping do
        indexes :email, index: 'not_analyzed'
        indexes :url, index: 'not_analyzed'
        indexes :origin_url, index: 'not_analyzed'
        indexes :target_url, index:'not_analyzed'
        indexes :lang, index:'not_analyzed'
        indexes :image,index: 'not_analyzed'
      end
    end
  end

  module Controller
    class HistoryController < ApplicationController
      def show
        id = params[:id]
        history = HistoryModel::Model::History.find_by(id: id)
        render json: history
      end
      
      def index
        histories = HistoryModel::Model::History.all
        render json: histories
      end
      
      def create
        enter_date = params[:enter_date]
        leave_time = params[:leave_time]
        focus_elasped_time = params[:focus_elasped_time]
        total_elasped_time = params[:total_elasped_time]
        history = HistoryModel::Model::History.create(email: params[:email],
                                                      url: params[:url],
                                                      origin_url: params[:origin_url],
                                                      target_url: params[:target_url],
                                                      lang: params[:lang],
                                                      title: params[:title],
                                                      description: params[:description],
                                                      image: params[:image],
                                                      search: params[:search],
                                                      enter_date: enter_date,
                                                      leave_time: leave_time,
                                                      focus_elasped_time: focus_elasped_time,
                                                      total_elasped_time: total_elasped_time)
        history.save
        render json: history
      end
      
      def destroy
        id = params[:id]
        history = HistoryModel::Model::History.find_by(id: id)
        if history != nil
          history.destroy
        end
        render json: history
      end
    end
  end
end
