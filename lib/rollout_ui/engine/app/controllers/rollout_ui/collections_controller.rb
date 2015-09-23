module RolloutUi
  class CollectionsController < RolloutUi::ApplicationController
    before_filter :wrapper, :only => [:index]

    def index
      @collections = @wrapper.collections.
                        map{ |collection| RolloutUi::Collection.new(collection) }
    end

    def update
      @collection           = RolloutUi::Collection.new(params[:id])
      @collection.user_ids  = params["users"]      if params["users"]

      redirect_to collections_path
    end

    def create
      wrapper.add_collection(params[:collection_name])
      redirect_to collections_path
    end

  private

    def wrapper
      @wrapper = RolloutUi::Wrapper.new
    end
  end
end
